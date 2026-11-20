import asyncio
from collections import defaultdict
import signal

from sniri import NiriConnection


async def focus_urgent(conn: NiriConnection, urgency_queue: dict[int, bool]):
  focus_window_cmd = lambda window_id: {'Action': {'FocusWindow': {'id': window_id}}}
  for window_id in list(reversed(urgency_queue)):
    print(f'Trying to focus most recently urgent window: {window_id}')
    await conn.command(focus_window_cmd(window_id))
    urgency_queue.pop(window_id, None)
    response = await conn.command('FocusedWindow')
    match response:
      case {'Ok': {'FocusedWindow': {'id': focused_window_id}}}:
        if focused_window_id == window_id:
          return

  windows = []
  match await conn.command('Windows'):
    case {'Ok': {'Windows': windows}}:
      pass
    case resp:
      print('Unknown response getting windows:', resp)
      return
  urgent_windows = [window for window in windows if window['is_urgent']]
  if not urgent_windows:
    print('No urgent windows to focus!')
    return

  if len(urgent_windows) == 1:
    window_id = urgent_windows[0]['id']
    print(f'Focusing only urgent window: {window_id}')
    await conn.command(focus_window_cmd(window_id))
    return

  # focus urgent window in most recently focused workspace
  workspace_most_recent_focus = defaultdict(int)
  for window in windows:
    workspace_id = window['workspace_id']
    workspace_most_recent_focus[workspace_id] = max(
      window['focus_timestamp']['nanos'], workspace_most_recent_focus[workspace_id]
    )

  window = max(
    urgent_windows, key=lambda window: workspace_most_recent_focus[window['workspace_id']]
  )
  window_id = window['id']
  print(f'Focusing urgent window in most recently focused workspace: {window_id}')
  await conn.command(focus_window_cmd(window_id))


async def main():
  urgency_queue: dict[int, bool] = {}
  loop = asyncio.get_running_loop()

  async with NiriConnection() as event_conn, NiriConnection() as conn:
    loop.add_signal_handler(
      signal.SIGUSR1, lambda: loop.create_task(focus_urgent(conn, urgency_queue))
    )
    async for event in event_conn.iter_event_stream():
      match event:
        case {'WindowUrgencyChanged': {'id': window_id, 'urgent': urgent}}:
          urgency_queue.pop(window_id, None)
          if urgent:
            urgency_queue[window_id] = True
          print(f'Urgency queue: {list(urgency_queue)}')


if __name__ == '__main__':
  try:
    asyncio.run(main())
  except KeyboardInterrupt:
    pass
