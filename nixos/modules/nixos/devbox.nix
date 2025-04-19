{ inputs, ... }:
{
  imports = [
    ./server.nix
    ./freshrss.nix
    inputs.srvos.nixosModules.mixins-nginx
  ];

  security.acme.defaults.email = "p0lyw0lf@protonmail.com";
  security.acme.acceptTerms = true;
}
