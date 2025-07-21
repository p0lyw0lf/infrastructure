{ flake, ... }:
{
  imports = [
    flake.nixosModules.server
    ./hardware-configuration.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";

  sops.defaultSopsFile = ../secrets.yaml;

  users.users.pw = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };
}
