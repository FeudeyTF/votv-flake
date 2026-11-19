{
  stdenv,
  fetchurl,
  p7zip,

}:
stdenv.mkDerivation (finalAttrs: {
  version = "0100_2";

  pname = "voices-of-the-void-unwrapped";

  src = fetchurl {
    url = "https://r2.votv.dev/archive/votv/${finalAttrs.version}.7z";
    hash = "sha256-78bMFPUhgJiYdn1DP8HI9iMB0EoVROutbFU3l8i0N3c=";
  };

  nativeBuildInputs = [
    p7zip
  ];

  unpackPhase = ''
    runHook preUnpack
    7z x "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/votv"
    cp -r "${finalAttrs.version}/WindowsNoEditor" "$out/share/votv/"

    runHook postInstall
  '';
})
