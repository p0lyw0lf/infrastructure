{ inputs, ... }:
{
  imports = [
    ./server.nix

    ./bot-crossposter.nix
    ./dotl-bud.nix
    ./freshrss.nix
    ./girl-technology.nix
    ./pds.nix
    ./rc-wolfgirl-dev.nix

    inputs.srvos.nixosModules.mixins-nginx
  ];

  security.acme.defaults.email = "p0lyw0lf@protonmail.com";
  security.acme.acceptTerms = true;
}
