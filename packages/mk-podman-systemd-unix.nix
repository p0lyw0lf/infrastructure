{
  pkgs,
  pname,
  description,
  secretEnv,
  composeFile,
  subst ? { },
  environment ? { },
}:
let
  podman-compose = pkgs.podman-compose;
in
import ./mk-systemd-unit.nix {
  inherit pname environment;

  package = podman-compose;
  serviceTemplateFile = ./podman-compose.service.in;

  subst = subst // {
    inherit
      description
      secretEnv
      composeFile
      podman-compose
      ;
    withSecretEnv = ../with_secret_env.sh;
  };
}
