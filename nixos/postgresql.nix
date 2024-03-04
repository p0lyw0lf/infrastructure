# Configuration for the postgres service
{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "girl.technology" ];
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type	database	DBuser	origin-address	auth-method
      #local
      local	all		all			trust
      #ipv4
      host 	all		all	127.0.0.1/32	trust
      #ipv6
      host 	all		all	::1/128		trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE nixos WITH LOGIN PASSWORD 'nixos' CREATEDB;
    '';
  };
}
