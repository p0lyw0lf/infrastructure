# Specification for all the packages to install by default
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cargo
    cmake
    curl
    difftastic
    fd
    git
    htop
    neovim
    nodejs
    python3
    ripgrep
    wget
  ];
  environment.variables.EDITOR = "nvim";
}
