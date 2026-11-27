{ pkgs, girl-technology, ... }:
{
  girl-technology = pkgs.callPackage (import ../mk-systemd-unit.nix {
    pname = "girl-technology";
    package = girl-technology.packages.girl-technology;
    serviceTemplateFile = ./girl.technology.service.in;
    environment = {
      DATABASE_URL = "postgres://ubuntu:passwd@localhost/girl.technology";
      GIRL_TECHNOLOGY_MAIN_DOMAIN = "girl.technology";
      GIRL_TECHNOLOGY_PORT = "3001";
    };
  }) { };
}
