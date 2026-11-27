{ pkgs, ... }:
{
  syncthing = pkgs.callPackage (import ../mk-podman-systemd-unix.nix {
    inherit pkgs;
    pname = "syncthing";
    description = "Syncthing run via Podman";
    secretEnv = ./secret.env;
    composeFile = ./docker-compose.yml;
  }) { };
}
