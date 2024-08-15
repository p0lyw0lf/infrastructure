# To shim this file into a NixOS installation:
# {
#   description = "NixOS Flake system configuration shim";
#
#   inputs = {
#     infrastructure.url = "git+file:///path/to/infrastructure?dir=nixos";
#   };
#
#   outputs = { self, infrastructure, ...}: infrastructure;
# }
{
  description = "NixOS system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, ...}: {
    nixosConfigurations.nixos-wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./packages.nix
        ./postgresql.nix
      ];
    };
  };
}
