from _mpd import client

t = client.currentsong()
print(t)
if 'pos' not in t:
  exit(1)
client.delete(t['pos'])
