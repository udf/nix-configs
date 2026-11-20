{
  lib,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage {
  pname = "sniri";
  version = "0.1.0";
  pyproject = true;

  src = ./.;

  build-system = [ setuptools ];

  pythonImportsCheck = [ "sniri" ];

  meta = {
    description = "Python connection helper for the Niri compositor's IPC";
    license = lib.licenses.mit;
  };
}
