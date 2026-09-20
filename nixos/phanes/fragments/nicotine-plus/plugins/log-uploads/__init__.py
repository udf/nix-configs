import os
import time
from typing import override
import json
from pathlib import Path

from pynicotine.pluginsystem import BasePlugin


class Plugin(BasePlugin):
  TEMP_LOG_SUFFIX: str = '.tmp'

  def __init__(self, *args, **kwargs):
    super().__init__(*args, **kwargs)
    self.settings = {
      'log_folder': '',
      'log_period': 600,
    }
    self.metasettings = {
      'log_folder': {
        'description': 'Folder where the upload log file is written',
        'group': 'Log Location',
        'type': 'file',
        'chooser': 'folder'
      },
      'log_period': {
        'description': 'How often in seconds to create a new log file',
        'group': 'Log Location',
        'type': 'int',
      },
    }
    self._last_log_path: Path | None = None

  @override
  def loaded_notification(self):
    if not self.settings['log_folder']:
      self.log('No log folder configured. Uploads will not be logged.')
      return

    try:
      os.makedirs(self.settings['log_folder'], exist_ok=True)
    except Exception as error:
      self.log('Failed to create log directory: %s', (error,))
      return

    self.log('Upload log will be written to %s', (self.settings['log_folder'],))
    self._finalize_log_files(self.settings['log_folder'])

  def _finalize_log_files(self, log_folder: str):
    for file in Path(log_folder).iterdir():
      if not file.is_file():
        continue
      if file.name.endswith(self.TEMP_LOG_SUFFIX):
        self._finalize_log_file(file, log=True)

  def _finalize_log_file(self, path: Path, log: bool=False):
    new_path = path.rename(path.with_name(path.name.removesuffix(self.TEMP_LOG_SUFFIX)))
    if log:
      self.log(f'Renamed: {str(path)!r} -> {str(new_path)!r}')

  def _get_tmp_log_path(self, log_folder: str, timestamp: int):
    return Path(log_folder) / f'{timestamp}.log{self.TEMP_LOG_SUFFIX}'

  def _get_log_file(self): 
    log_folder: str = self.settings['log_folder']  # pyright: ignore[reportAssignmentType]
    if not log_folder:
      return
    log_period = int(self.settings['log_period'])
    log_timestamp = int(time.time() // log_period) * log_period
    log_path = self._get_tmp_log_path(log_folder, log_timestamp)

    if log_path != self._last_log_path and self._last_log_path and self._last_log_path.exists():
      self._finalize_log_file(self._last_log_path)

    self._last_log_path = log_path
    return self._last_log_path

  @override
  def upload_queued_notification(self, user, virtual_path, real_path):
    log_file = self._get_log_file()
    if not log_file:
      return

    line = json.dumps({
      'user': user,
      'timestamp': time.time(),
      'path': real_path
    })

    with open(log_file, 'a', encoding='utf-8') as f:
      f.write(line)
      f.write('\n')
