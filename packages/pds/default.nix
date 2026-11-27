{ pkgs, ... }:
{
  pds = pkgs.callPackage (import ../mk-systemd-unit.nix {
    pname = "pds";
    package = pkgs.bluesky-pds;
    serviceTemplateFile = ./pds.service.in;
  }) { };
}
