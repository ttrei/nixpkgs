{ stdenv, fetchgit, cmake, gcc, boost, freetype, glew}:

stdenv.mkDerivation rec {
  name = "gltools";
  version = "0.1";

  src = fetchgit {
    url = "/var/tmp/gltools.git";
    rev = "refs/heads/master";
    sha256 = "0nyk8nkw27s59yi08g2xvyz1h94g0igm83wq76dv9djb04axrdx4";
  };

  nativeBuildInputs = [ gcc cmake ];

  buildInputs = [ boost freetype glew ];
}
