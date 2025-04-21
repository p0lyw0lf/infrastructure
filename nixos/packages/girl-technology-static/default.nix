{
  pkgs,
  perSystem,
  ...
}:
pkgs.callPackage (import ./package.nix) { girl-technology = perSystem.self.girl-technology; }
