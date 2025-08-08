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
      nixos-anywhere
      nixos-rebuild
      pwgen
      qemu
      sops
      ssh-to-age
      zstd
    ]);

  # Add environment variables
  env = { };

  # Load custom bash code
  shellHook = ''

  '';
}
