{ inputs, flake, ... }:
{
  imports = [
    inputs.disko.nixosModules.default
    inputs.sops-nix.nixosModules.default
    inputs.srvos.nixosModules.server
  ];

  users.users.root.openssh.authorizedKeys.keyFiles = [
    "${flake}/users/wsl/authorized_keys"
  ];
}
