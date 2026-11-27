import asyncio
from collections import defaultdict
import logging
import signal
import os

from snirid import SniridEvent, snirid

logger = logging.getLogger(snirid.plugin_namespace)
urgency_queue: dict[int, bool] = {}


async def focus_urgent():
  focus_window_cmd = lambda window_id: {'Action': {'FocusWindow': {'id': window_id}}}
  for window_id in list(reversed(urgency_queue)):
    if not snirid.get_cached_window(window_id):
      logger.info(f'Skipping missing window: {window_id}')
      urgency_queue.pop(window_id, None)
      continue
    logger.info(f'Trying to focus most recently urgent window: {window_id}')
    await snirid.command(focus_window_cmd(window_id))
    urgency_queue.pop(window_id, None)
    response = await snirid.command('FocusedWindow')
    match response:
      case {'Ok': {'FocusedWindow': {'id': focused_window_id}}}:
        if focused_window_id == window_id:
          return

  windows = []
  match await snirid.command('Windows'):
    case {'Ok': {'Windows': windows}}:
      pass
    case resp:
      logger.info('Unknown response getting windows:', resp)
      return
  urgent_windows = [window for window in windows if window['is_urgent']]
  if not urgent_windows:
    logger.info('No urgent windows to focus!')
    return

  if len(urgent_windows) == 1:
    window_id = urgent_windows[0]['id']
    logger.info(f'Focusing only urgent window: {window_id}')
    await snirid.command(focus_window_cmd(window_id))
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
  logger.info(f'Focusing urgent window in most recently focused workspace: {window_id}')
  await snirid.command(focus_window_cmd(window_id))


@snirid.on('WindowUrgencyChanged')
async def on_urgency_change(event: SniridEvent):
  match event.data:
    case {'id': window_id, 'urgent': urgent}:
      urgency_queue.pop(window_id, None)
      if urgent:
        urgency_queue[window_id] = True
      logger.info(f'Urgency queue: {list(urgency_queue)}')


loop = asyncio.get_running_loop()
loop.add_signal_handler(signal.SIGUSR1, lambda: loop.create_task(focus_urgent()))
logger.info(f'pid: {os.getpid()}')
