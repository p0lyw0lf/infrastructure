{ flake, ... }:
{
  imports = [
    flake.nixosModules.server
    ./hardware-configuration.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking.hostName = "gbox";
  networking.domain = "us-central1-c.c.solar-attic-303316.internal";

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "24.05";
}
