import asyncio
import os

from dbus_fast import BusType
from dbus_fast.aio import MessageBus

BUS_NAME = 'org.mpris.MediaPlayer2.playerctld'
OBJECT_PATH = '/org/mpris/MediaPlayer2'
PLAYER_INTERFACE = 'org.mpris.MediaPlayer2.Player'
BATCH_INTERVAL_SECONDS = 0.05
SOCKET_PATH = os.environ.get(
  'PLAYERCTLD_SEEK_SOCKET',
  os.path.join(os.environ.get('XDG_RUNTIME_DIR', '/tmp'), 'playerctld-seekd.sock'),
)


class SeekDaemon:
  def __init__(self):
    self.pending_seek = 0
    self.player = None
    self.batch_ready = asyncio.Event()
    self.batch_timer = None

  def schedule_seek_batch(self):
    if self.batch_timer is not None:
      return

    loop = asyncio.get_running_loop()

    def fire_batch():
      self.batch_timer = None
      self.batch_ready.set()

    self.batch_timer = loop.call_later(BATCH_INTERVAL_SECONDS, fire_batch)

  async def connect(self):
    bus = await MessageBus(bus_type=BusType.SESSION).connect()
    introspection = await bus.introspect(BUS_NAME, OBJECT_PATH)
    proxy = bus.get_proxy_object(BUS_NAME, OBJECT_PATH, introspection)
    self.player = proxy.get_interface(PLAYER_INTERFACE)

  async def handle_connection(self, reader, writer):
    try:
      data = await reader.read()
      seek = int(data.strip())
      self.pending_seek += seek
      if seek:
        self.schedule_seek_batch()
    except (ValueError, AttributeError):
      pass
    finally:
      writer.close()
      await writer.wait_closed()

  async def batch_seek_loop(self):
    while True:
      await self.batch_ready.wait()
      self.batch_ready.clear()

      if self.pending_seek == 0:
        continue

      offset = self.pending_seek
      self.pending_seek = 0
      try:
        await self.player.call_seek(offset)
      except Exception as error:
        print(f'Failed to seek: {error}', flush=True)


async def main():
  daemon = SeekDaemon()
  await daemon.connect()

  try:
    os.unlink(SOCKET_PATH)
  except FileNotFoundError:
    pass

  server = await asyncio.start_unix_server(
    daemon.handle_connection,
    path=SOCKET_PATH,
  )
  os.chmod(SOCKET_PATH, 0o600)

  batch_task = asyncio.create_task(daemon.batch_seek_loop())
  async with server:
    await server.serve_forever()


if __name__ == '__main__':
  try:
    asyncio.run(main())
  except KeyboardInterrupt:
    pass
