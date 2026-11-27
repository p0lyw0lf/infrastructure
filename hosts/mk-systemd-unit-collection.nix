units:
{ pkgs, ... }@inp:
let
  units-of = unit: builtins.attrValues (import unit inp);
  all-units = builtins.concatMap units-of units;
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
    ${builtins.concatStringsSep "\n" (map (unit: "cp ${unit}/*.service $out") all-units)}

    runHook postInstall
  '';
}
