import os
import re
from mpd import MPDClient

client = MPDClient()
host, port = 'localhost', 6600
password = ''
m = re.match(r'^(?P<pw>.*)@(?P<host>.+?):?(?P<port>\d+)?$', os.environ.get('MPD_HOST', ''))
if m:
  host = m['host']
  port = int(m['port']) if m['port'] else None
  password = m['pw']
client.connect(host, port)
if password:
  client.password(password)
