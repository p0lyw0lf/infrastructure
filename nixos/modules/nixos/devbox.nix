{ inputs, ... }:
{
  imports = [
    ./server.nix

    # ./bot-crossposter.nix
    ./freshrss.nix
    ./girl-technology.nix
    ./rc-wolfgirl-dev.nix
    ./pds.nix

    inputs.srvos.nixosModules.mixins-nginx
  ];

  security.acme.defaults.email = "p0lyw0lf@protonmail.com";
  security.acme.acceptTerms = true;
}
