{ stdenv, fetchgit, cmake, gcc, boost, freetype, glew}:

stdenv.mkDerivation rec {
  name = "gltools";
  version = "0.1";

  src = fetchgit {
    url = "/var/tmp/gltools.git";
    rev = "f27ce38fd36c6177a5a34fcea44a5e8b46a54b4f";
    sha256 = "1zi1sa3akc8jcwyn0iyj34h1dpqzcwax27khd0xsgg2mbqlyi4rc";
  };

  nativeBuildInputs = [ gcc cmake ];

  buildInputs = [ boost freetype glew ];
}
