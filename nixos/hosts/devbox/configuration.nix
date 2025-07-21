{ flake, ... }:
{
  imports = [
    flake.nixosModules.server
    ./hardware-configuration.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  networking.hostName = "devbox";
  networking.domain = "";

  sops.defaultSopsFile = ../secrets.yaml;

  system.stateVersion = "24.05";
}
