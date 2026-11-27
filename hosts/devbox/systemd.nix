{ pkgs, ... }@inp:
let
  units = file: builtins.attrValues (import file inp);
  all-units = builtins.concatLists (
    map units [
      ../../packages/crossposter
      ../../packages/pds
    ]
  );
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
