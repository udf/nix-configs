import asyncio
import signal

from sniri import NiriConnection


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
