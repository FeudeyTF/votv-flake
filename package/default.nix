{
  lib,
  writeShellScript,
  stdenv,
  makeWrapper,
  callPackage,
  wineWow64Packages,
  winetricks,
  makeDesktopItem,
  unwrapped ? callPackage ./votv.nix { },
  extraVariables ? { },
}:
let
  wine = wineWow64Packages.stable;

  launcher = import ./launcher.nix { inherit writeShellScript; };

  desktopItem = makeDesktopItem {
    name = "votv";
    exec = "votv";
    icon = "votv";
    desktopName = "Voices of the Void";
    genericName = "VotV";
    categories = [ "Game" ];
  };

  runtimePath = lib.makeBinPath [
    wine
    winetricks
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "voices-of-the-void";
  version = "0100_2";

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out/bin"

    install -Dm755 ${launcher} "$out/libexec/votv-launcher"

    makeWrapper "$out/libexec/votv-launcher" "$out/bin/votv" \
      --prefix PATH : "${runtimePath}" \
      --set WINE "${wine}/bin/wine" \
      --set WINESERVER "${wine}/bin/wineserver" \
      --set VOTV_DIR "${unwrapped}/share/votv/WindowsNoEditor" \
      --set VOTV_EXE "${unwrapped}/share/votv/WindowsNoEditor/VotV.exe" \
      ${lib.concatMapAttrsStringSep " \\\n" (name: value: "--set ${name} \"${value}\"") extraVariables}

    install -Dm644 ${desktopItem}/share/applications/votv.desktop \
      "$out/share/applications/votv.desktop"
  '';

  meta = {
    description = "Voices of the Void";
    homepage = "https://mrdrnose.itch.io/votv";
    #   license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainProgram = "votv";
  };
})
