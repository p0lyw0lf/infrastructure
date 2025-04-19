{ pkgs, perSystem }:
pkgs.mkShell {
  # Add build dependencies
  packages =
    (with perSystem; [
      sops-nix.default
    ])
    ++ (with pkgs; [
      nixos-rebuild
      age
      pwgen
      sops
      ssh-to-age
    ]);

  # Add environment variables
  env = { };

  # Load custom bash code
  shellHook = ''

  '';
}
