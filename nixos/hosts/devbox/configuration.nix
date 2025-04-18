{ flake, ... }:
{
  imports = [
    ./disko.nix
    flake.nixosModules.server
    # TODO: get this from nixos-anywhere
    ./oracle-hardware-configuration.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  networking.hostName = "devbox";

  # TODO: networking?
  # systemd.network

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "24.05";
}
