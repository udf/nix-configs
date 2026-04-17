# setty: set operations on lines of files

import operator
import sys
import ast

from boltons.setutils import IndexedSet


OPS = {
  ast.Add: operator.or_,
  ast.BitOr: operator.or_,
  ast.Sub: operator.sub,
  ast.BitAnd: operator.and_,
  ast.BitXor: operator.xor
}


def read_set_lines(path):
  s = IndexedSet()
  with open(path) as f:
    for line in f:
      s.add(line.rstrip('\n'))
  return s


def concat_attrs(node: ast.AST):
  match node:
    case ast.Attribute():
      return concat_attrs(node.value) + '.' + node.attr
    case ast.Name():
      return node.id
    case _:
      raise NotImplementedError(f'Unimplemented node in attribute tree {node}')


def setty(node: ast.AST):
  match node:
    case ast.BinOp():
      op = OPS.get(type(node.op), None)
      if not op:
        raise NotImplementedError(f'Unimplemented operator {node.op}')
      return op(setty(node.left), setty(node.right))
    case ast.Name():
      return read_set_lines(node.id)
    case ast.Constant():
      return read_set_lines(node.value)
    case ast.Attribute():
      # a.b means read a file called "a.b"
      return read_set_lines(concat_attrs(node))
    case _:
      raise NotImplementedError(f'Unimplemented node {node}')


if __name__ == '__main__':
  expr = ast.parse(' '.join(sys.argv[1:]), mode="eval")

  try:
    print('\n'.join(setty(expr.body)))
  except:
    print('Exception raised, dumping ast:')
    print(ast.dump(expr, indent=4))
    print()
    raise
