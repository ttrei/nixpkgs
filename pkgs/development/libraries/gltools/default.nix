{ stdenv, fetchgitPrivate, cmake, gcc, boost, freetype, glew}:

stdenv.mkDerivation rec {
  name = "gltools";
  version = "0.1";

  src = fetchgitPrivate {
    url = "ssh://mazais-fetchgit:/home/reinis/projects/gltools.git";
    rev = "e91924a6a0fb7be0901104c629915bae2ed8a62e";
    sha256 = "0bh4q7326842qn2vcm2ifq0qk810rpnsfppblwjgz5ydvp3dsbjc";
  };

  nativeBuildInputs = [ gcc cmake ];

  propagatedBuildInputs = [ boost freetype glew ];
}
