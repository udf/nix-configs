import asyncio
import json
import os
import sys

SOCKET_PATH = os.environ.get("NIRI_SOCKET")


class NiriConnection:
  def __init__(self, socket_path: str | None = None):
    self.socket_path = socket_path or SOCKET_PATH
    if not self.socket_path:
      raise RuntimeError("NIRI_SOCKET environment variable not set")

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
        "Cannot send commands after starting iter_event_stream() on this connection; open a separate connection for commands."
      )

    payload = json.dumps(payload_obj) + "\n"
    self.writer.write(payload.encode("utf-8"))
    await self.writer.drain()

    line = await self.reader.readline()
    if not line:
      raise ConnectionError("Niri socket closed before responding")

    return json.loads(line.decode("utf-8"))

  async def iter_event_stream(self):
    if self.reader is None or self.writer is None:
      raise RuntimeError('Connection is not open. Use "async with NiriConnection() as conn:"')
    if self._event_stream_started:
      raise RuntimeError(
        "Event stream already started for this connection; use a separate connection for commands."
      )

    self._event_stream_started = True
    payload = json.dumps({"EventStream": None}) + "\n"
    self.writer.write(payload.encode("utf-8"))
    await self.writer.drain()

    while True:
      line = await self.reader.readline()
      if not line:
        break

      decoded_line = line.decode("utf-8").strip()
      if not decoded_line:
        continue

      try:
        event = json.loads(decoded_line)
        yield event
      except json.JSONDecodeError:
        print(f"Failed to parse event line: {decoded_line}", file=sys.stderr)
