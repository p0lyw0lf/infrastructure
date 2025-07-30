{ flake, ... }:
{
  imports = [
    flake.nixosModules.devbox
    ./hardware-configuration.nix
  ];

  devbox.dotl-bud.enable = true;

  system.stateVersion = "25.05";

  sops.defaultSopsFile = ../secrets.yaml;

  users.users.pw = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };
}
