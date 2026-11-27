{ pkgs, ... }:
{
  freshrss = pkgs.callPackage (import ../mk-podman-systemd-unix.nix {
    inherit pkgs;
    pname = "freshrss";
    description = "Freshrss run via Podman";
    secretEnv = ./secret.env;
    composeFile = ./docker-compose.yml;
  }) { };
}
