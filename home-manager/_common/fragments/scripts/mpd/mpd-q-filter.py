#!/usr/bin/env python
import operator
import argparse
from _mpd import client


parser = argparse.ArgumentParser()
parser.add_argument('--invert', action='store_true')
parser.add_argument('op', nargs='?', default='=')
parser.add_argument('rating', type=int, choices=range(0, 11))
args = parser.parse_args()

filter_op = {
  '=': operator.eq,
  '>': operator.ge,
  '<': operator.le,
}[args.op]

filter_fn = filter_op
if args.invert:
  filter_fn = lambda *a: not filter_op(*a)

ratings = {
  v['file']: int(v['sticker'].lstrip('rating='))
  for v in client.sticker_find('song', '', 'rating', '>', 0)
}

queue = client.playlistinfo()
queue = {v['id']: ratings.get(v['file'], 0) for v in queue}

print(f'{len(queue)} files in queue')
to_remove = [id for id, rating in queue.items() if not filter_fn(rating, args.rating)]
num_matching = len(queue) - len(to_remove)
print(f'{num_matching} matching filter')

if len(queue) == len(to_remove) or not (input('Proceed Y/n? ').strip() or 'y').lower().startswith('y'):
  exit(1)

for id in reversed(to_remove):
  client.deleteid(id)