{ pkgs, crossposter }:
{
  crossposter = pkgs.callPackage (import ../mk-systemd-unit.nix {
    pname = "crossposter";
    package = crossposter.packages.bot-crossposter;
    serviceTemplateFile = ./crossposter.service.in;
  }) { };

  rc-wolfgirl-dev = pkgs.callPackage (import ../mk-systemd-unit.nix {
    pname = "rc-wolfgirl-dev";
    package = crossposter.packages.rc-crossposter;
    serviceTemplateFile = ./rc.wolfgirl.dev.service.in;
  }) { };
}
