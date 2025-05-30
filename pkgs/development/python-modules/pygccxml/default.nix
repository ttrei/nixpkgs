{
  lib,
  castxml,
  fetchFromGitHub,
  buildPythonPackage,
  llvmPackages,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pygccxml";
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gccxml";
    repo = "pygccxml";
    tag = "v${version}";
    hash = "sha256-pIo25/tKiXpyiWUkpILPDPTNWIUEGK4uRSTpvoGwS1Q=";
  };

  nativeBuildInputs = [ setuptools ];

  buildInputs = [
    castxml
    llvmPackages.libcxxStdenv
  ];

  # running the suite is hard, needs to generate xml_generator.cfg
  # but the format doesn't accept -isystem directives
  doCheck = false;

  meta = with lib; {
    description = "Python package for easy C++ declarations navigation";
    homepage = "https://github.com/gccxml/pygccxml";
    changelog = "https://github.com/CastXML/pygccxml/blob/${src.tag}/CHANGELOG.md";
    license = licenses.boost;
    maintainers = with maintainers; [ teto ];
  };
}
