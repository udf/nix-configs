import asyncio
import json
import os
import sys
import signal

SOCKET_PATH = os.environ.get('NIRI_SOCKET')

if not SOCKET_PATH:
  print(
    'Error: $NIRI_SOCKET environment variable not set.',
    file=sys.stderr,
  )
  exit(1)


class NiriConnection:
  def __init__(self, socket_path: str | None = None):
    self.socket_path = socket_path or SOCKET_PATH
    self.reader: asyncio.StreamReader | None = None
    self.writer: asyncio.StreamWriter | None = None
    self._event_stream_started: bool = False

  async def __aenter__(self):
    self.reader, self.writer = await asyncio.open_unix_connection(self.socket_path)
    return self

  async def __aexit__(self, exc_type, exc, tb):
    if self.writer is not None:
      self.writer.close()
      await self.writer.wait_closed()
    self.reader = None
    self.writer = None

  async def command(self, payload_obj: dict | str) -> dict:
    if self.reader is None or self.writer is None:
      raise RuntimeError('Connection is not open. Use "async with NiriConnection() as conn:"')
    if self._event_stream_started:
      raise RuntimeError(
        'Cannot send commands after starting iter_event_stream() on this connection; open a separate connection for commands.'
      )

    payload = json.dumps(payload_obj) + '\n'
    self.writer.write(payload.encode('utf-8'))
    await self.writer.drain()

    line = await self.reader.readline()
    if not line:
      raise ConnectionError('Niri socket closed before responding')

    return json.loads(line.decode('utf-8'))

  async def iter_event_stream(self):
    if self.reader is None or self.writer is None:
      raise RuntimeError('Connection is not open. Use "async with NiriConnection() as conn:"')
    if self._event_stream_started:
      raise RuntimeError(
        'Event stream already started for this connection; use a separate connection for commands.'
      )

    self._event_stream_started = True
    payload = json.dumps({'EventStream': None}) + '\n'
    self.writer.write(payload.encode('utf-8'))
    await self.writer.drain()

    while True:
      line = await self.reader.readline()
      if not line:
        break

      decoded_line = line.decode('utf-8').strip()
      if not decoded_line:
        continue

      try:
        event = json.loads(decoded_line)
        yield event
      except json.JSONDecodeError:
        print(
          f'Failed to parse event line: {decoded_line}',
          file=sys.stderr,
        )


async def focus_urgent(conn: NiriConnection, urgency_queue: dict[int, bool]):
  focus_window_cmd = lambda window_id: {'Action': {'FocusWindow': {'id': window_id}}}
  for window_id in list(reversed(urgency_queue)):
    print(f'Trying to focus most recently urgent window: {window_id}')
    await conn.command(focus_window_cmd(window_id))
    urgency_queue.pop(window_id, None)
    response = await conn.command('FocusedWindow')
    if response['Ok'].get('FocusedWindow', {}).get('id', None) == window_id:
      return
  windows_rsp = await conn.command('Windows')
  urgent_windows = [window for window in windows_rsp['Ok']['Windows'] if window['is_urgent']]
  if not urgent_windows:
    print('No urgent windows to focus!')
    return
  current_workspace_id = [
    window for window in windows_rsp['Ok']['Windows'] if window['is_focused']
  ][0]['workspace_id']
  urgent_windows = sorted(
    urgent_windows,
    key=lambda window:
    (abs(current_workspace_id - window['workspace_id']), -window['focus_timestamp']['nanos'])
  )

  window_id = urgent_windows[0]['id']
  print(f'Focusing closest, most recently focused urgent window: {window_id}')
  await conn.command(focus_window_cmd(window_id))


async def main():
  urgency_queue: dict[int, bool] = {}
  loop = asyncio.get_running_loop()

  async with NiriConnection() as event_conn, NiriConnection() as conn:
    loop.add_signal_handler(
      signal.SIGUSR1, lambda: loop.create_task(focus_urgent(conn, urgency_queue))
    )
    async for event in event_conn.iter_event_stream():
      urgency_event = event.get('WindowUrgencyChanged', None)
      if urgency_event:
        window_id = int(urgency_event['id'])
        urgency_queue.pop(window_id, None)
        if urgency_event['urgent']:
          urgency_queue[window_id] = True
        print(f'Urgency queue: {list(urgency_queue)}')


if __name__ == '__main__':
  try:
    asyncio.run(main())
  except KeyboardInterrupt:
    pass
