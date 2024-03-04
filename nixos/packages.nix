# Specification for all the packages to install by default
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cmake
    curl
    fd
    git
    neovim
    nodejs
    python3
    ripgrep
    wget
  ];
  environment.variables.EDITOR = "nvim";
}
