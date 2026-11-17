import argparse

from _mpd import client

parser = argparse.ArgumentParser()
parser.add_argument('rating', type=int, choices=range(0, 11))
parser.add_argument('--go-next', action='store_true')
args = parser.parse_args()

cur = client.currentsong()
client.sticker_set('song', cur['file'], 'rating', args.rating)
if args.go_next:
  client.next()
