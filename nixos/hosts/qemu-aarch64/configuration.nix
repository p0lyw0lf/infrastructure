{ flake, ... }:
{
  imports = [
    flake.nixosModules.devbox
    ./hardware-configuration.nix
  ];

  disko.devices.disk.disk1.device = "/dev/vda";

  devbox.dotl-bud.enable = true;

  system.stateVersion = "25.05";

  sops.defaultSopsFile = ../secrets.yaml;

  users.users.pw = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };
}
