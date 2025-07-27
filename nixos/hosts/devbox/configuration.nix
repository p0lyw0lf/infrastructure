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

  users.users.polywolf = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGQYrxiNsD7iofw/Q+Fjp5rkE2V/wA4Y4vAKQ+eAmP/ nixos@nixos-wsl"
    ];
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
