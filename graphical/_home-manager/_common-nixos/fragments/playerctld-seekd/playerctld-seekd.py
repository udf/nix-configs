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
    self.message_bus: MessageBus | None = None
    self.batch_ready = asyncio.Event()

  async def connect(self):
    self.message_bus = await MessageBus(bus_type=BusType.SESSION).connect()
    introspection = await self.message_bus.introspect(BUS_NAME, OBJECT_PATH)
    proxy = self.message_bus.get_proxy_object(BUS_NAME, OBJECT_PATH, introspection)
    self.player = proxy.get_interface(PLAYER_INTERFACE)

  async def handle_connection(self, reader: asyncio.StreamReader, writer: asyncio.StreamWriter):
    try:
      data = await reader.read(128)
      seek = int(data.strip())
      self.pending_seek += seek
      if self.pending_seek:
        self.batch_ready.set()
    except (ValueError, AttributeError):
      pass
    finally:
      writer.close()
      await writer.wait_closed()

  async def batch_seek_loop(self):
    while True:
      await self.batch_ready.wait()
      self.batch_ready.clear()
      await asyncio.sleep(BATCH_INTERVAL_SECONDS)

      if self.pending_seek == 0:
        continue

      offset = self.pending_seek
      self.pending_seek = 0
      try:
        await self.player.call_seek(offset)
      except Exception as error:
        print(f'Failed to seek: {error}', flush=True)
        raise


async def main():
  daemon = SeekDaemon()
  await daemon.connect()

  os.umask(0o177)
  server = await asyncio.start_unix_server(
    daemon.handle_connection,
    path=SOCKET_PATH,
  )

  batch_task = asyncio.create_task(daemon.batch_seek_loop())
  async with server:
    serve_task = asyncio.create_task(server.serve_forever())
    done, pending = await asyncio.wait(
      (serve_task, batch_task),
      return_when=asyncio.FIRST_COMPLETED,
    )
    for completed_task in done:
      await completed_task


if __name__ == '__main__':
  try:
    asyncio.run(main())
  except KeyboardInterrupt:
    pass
