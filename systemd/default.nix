{ pkgs, crossposter }:
let
  crossposter-units = import ../packages/crossposter { inherit pkgs crossposter; };
  all-units = builtins.attrValues crossposter-units;
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "systemd-units";
  version = "0.1.0";

  buildInputs = all-units;

  src = null;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    ${pkgs.lib.concatStrings (
      map (unit: ''
        cp ${unit}/*.service $out
      '') all-units
    )}

    runHook postInstall
  '';
}
