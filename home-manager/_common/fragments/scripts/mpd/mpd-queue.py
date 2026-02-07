import sys
from _mpd import client

for line in sys.stdin.readlines():
  client.add(line.rstrip('\n'))
