{ pkgs, perSystem }:
pkgs.mkShell {
  # Add build dependencies
  packages =
    (with perSystem; [
      sops-nix.default
    ])
    ++ (with pkgs; [
      age
      just
      nix-output-monitor
      nixos-rebuild
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
