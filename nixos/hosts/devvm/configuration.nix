{ flake, ... }:
{
  imports = [
    flake.nixosModules.devbox
    ./hardware-configuration.nix
  ];

  devbox.dotl-bud.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";

  sops.defaultSopsFile = ../secrets.yaml;

  users.users.pw = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };
}
