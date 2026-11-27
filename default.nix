let
  sources = import ./npins;
  pkgs = import sources.nixpkgs { };
  crossposter = import sources.crossposter { inherit pkgs; };
  girl-technology = import sources.girl-technology { inherit pkgs; };
in
{
  devbox = import ./hosts/devbox { inherit pkgs crossposter girl-technology; };
}
