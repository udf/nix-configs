{
  pythonPkg,
  pkgs,
  readOnly ? false,
}:
''
  # allow pip to install wheels
  unset SOURCE_DATE_EPOCH
  # ensure that we rebuild the venv when the python package changes
  VENV_DIR=".venv-${builtins.baseNameOf (builtins.toString pythonPkg)}-3"
  shopt -s nullglob
  for other_venv in .venv-*; do
    if [ "$other_venv" != "$VENV_DIR" ]; then
      echo Removing unused venv: "$other_venv"
      rm -fr "$other_venv"
    fi
  done
  shopt -u nullglob
  IS_NEW_VENV=false
  if [ ! -d "$VENV_DIR" ]; then
    ${
      if readOnly then
        ''
          echo "venv dir '$VENV_DIR' not found, bailing out" >&2
          exit 1
        ''
      else
        ""
    }
    echo "Creating new venv environment in path: '$VENV_DIR'"
    ${pythonPkg}/bin/python -m venv "$VENV_DIR" --system-site-packages
    export PYTHONHOME=${pythonPkg}/bin
    # point home in pyvenv.cfg to the correct site packages (venv module bug?)
    ${pkgs.gawk}/bin/gawk -i inplace \
      '{sub(/(home = ).+/, "home = " ENVIRON["PYTHONHOME"])}1' \
      "$VENV_DIR/pyvenv.cfg"
    source "$VENV_DIR/bin/activate"
    IS_NEW_VENV=true
  else
    source "$VENV_DIR/bin/activate"
  fi
''
