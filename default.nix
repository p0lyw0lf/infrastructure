let
  sources = import ./npins;
  pkgs = import sources.nixpkgs { };
  crossposter = import sources.crossposter { inherit pkgs; };
in
{
  packages = {
    systemd = import ./systemd { inherit pkgs crossposter; };
  };
}
