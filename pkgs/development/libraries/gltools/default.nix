{ stdenv, fetchgitPrivate, cmake, gcc, boost, freetype, glew}:

stdenv.mkDerivation rec {
  name = "gltools";
  version = "0.1";

  src = fetchgitPrivate {
    url = "ssh://mazais-fetchgit:/home/reinis/projects/gltools.git";
    rev = "e7348a483697fd5935effebb7299021f3dea7b42";
    sha256 = "0m80mqlrj5sgm12maj4srdsh319a477wmp4hisl2fyawwqm935fr";
  };

  nativeBuildInputs = [ gcc cmake ];

  propagatedBuildInputs = [ boost freetype glew ];
}
