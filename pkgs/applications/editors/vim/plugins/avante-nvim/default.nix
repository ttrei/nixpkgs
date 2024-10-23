{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  vimUtils,
  darwin,
}:

let
  version = "2024-10-22";

  src = fetchFromGitHub {
    owner = "yetone";
    repo = "avante.nvim";
    rev = "a8e2b9a00c73b11d28857f0f5de79a9022281182";
    hash = "sha256-72kNp+jH4fUevR1jb8gIOwaG6KvjmCx4B74TzitSSyY=";
  };

  meta = with lib; {
    description = "Neovim plugin designed to emulate the behaviour of the Cursor AI IDE";
    homepage = "https://github.com/yetone/avante.nvim";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [
      ttrei
      aarnphm
    ];
  };

  avante-nvim-lib = rustPlatform.buildRustPackage {
    pname = "avante-nvim-lib";
    inherit version src meta;
    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "mlua-0.10.0-beta.1" = "sha256-ZEZFATVldwj0pmlmi0s5VT0eABA15qKhgjmganrhGBY=";
      };
    };

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs =
      [
        openssl
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        darwin.apple_sdk.frameworks.Security
      ];

    buildFeatures = [ "luajit" ];
  };
in

vimUtils.buildVimPlugin {
  pname = "avante.nvim";
  inherit version src meta;

  postInstall =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mkdir -p $out/build
      ln -s ${avante-nvim-lib}/lib/libavante_repo_map${ext} $out/build/avante_repo_map${ext}
      ln -s ${avante-nvim-lib}/lib/libavante_templates${ext} $out/build/avante_templates${ext}
      ln -s ${avante-nvim-lib}/lib/libavante_tokenizers${ext} $out/build/avante_tokenizers${ext}
    '';

  doInstallCheck = true;
  nvimRequireCheck = "avante";
}
