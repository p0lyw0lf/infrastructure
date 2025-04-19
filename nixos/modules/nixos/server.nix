{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.default
    inputs.srvos.nixosModules.server
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGQYrxiNsD7iofw/Q+Fjp5rkE2V/wA4Y4vAKQ+eAmP/ nixos@nixos-wsl"
  ];
}
