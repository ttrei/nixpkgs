{
  pname,
  version,
  hash,
  autoPatchelfHook,
  copyDesktopItems,
  fetchurl,
  fontconfig,
  freetype,
  lib,
  libGL,
  libxkbcommon,
  makeDesktopItem,
  makeWrapper,
  stdenvNoCC,
  unzip,
  writeShellApplication,
  xorg,
  zlib,
  metaCommon ? { },
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version;

  src = fetchurl {
    name = "WinBox_Linux-${finalAttrs.version}.zip";
    url = "https://download.mikrotik.com/routeros/winbox/${finalAttrs.version}/WinBox_Linux.zip";
    inherit hash;
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    # makeBinaryWrapper does not support --run
    makeWrapper
    unzip
  ];

  buildInputs = [
    fontconfig
    freetype
    libGL
    libxkbcommon
    xorg.libxcb
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 "assets/img/winbox.png" "$out/share/pixmaps/winbox.png"
    install -Dm755 "WinBox" "$out/bin/WinBox"

    wrapProgram "$out/bin/WinBox" --run "${lib.getExe finalAttrs.migrationScript}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "winbox";
      desktopName = "WinBox";
      comment = "GUI administration for Mikrotik RouterOS";
      exec = "WinBox";
      icon = "winbox";
      categories = [ "Utility" ];
    })
  ];

  migrationScript = writeShellApplication {
    name = "winbox-migrate";
    text = ''
      XDG_DATA_HOME=''${XDG_DATA_HOME:-$HOME/.local/share}
      targetFile="$XDG_DATA_HOME/MikroTik/WinBox/Addresses.cdb"

      if [ -f "$targetFile" ]; then
        echo "NixOS: WinBox 4 data already present at $(dirname "$targetFile"). Skipping automatic migration."
        exit 0
      fi

      # cover both wine prefix variants
      # latter was used until https://github.com/NixOS/nixpkgs/pull/329626 was merged on 2024/07/24
      winePrefixes=(
        "''${WINEPREFIX:-$HOME/.wine}"
        "''${WINBOX_HOME:-$XDG_DATA_HOME/winbox}/wine"
      )
      sourceFilePathSuffix="drive_c/users/$USER/AppData/Roaming/Mikrotik/Winbox/Addresses.cdb"
      selectedSourceFile=""

      for prefix in "''${winePrefixes[@]}"
      do
        echo "NixOS: Probing WinBox 3 data path at $prefix..."
        if [ -f "$prefix/$sourceFilePathSuffix" ]; then
          selectedSourceFile="$prefix/$sourceFilePathSuffix"
          break
        fi
      done

      if [ -z "$selectedSourceFile" ]; then
        echo "NixOS: WinBox 3 data not found. Skipping automatic migration."
        exit 0
      fi

      echo "NixOS: Automatically migrating WinBox 3 data..."
      install -Dvm644 "$selectedSourceFile" "$targetFile"
    '';
  };

  meta = metaCommon // {
    platforms = [ "x86_64-linux" ];
  };
})
