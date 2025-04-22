{
  config,
  lib,
  pkgs,
  perSystem,
  ...
}:
let
  cfg = config.devbox.girl-technology;
in
{
  imports = [
    ./nginx-wildcard.nix
  ];

  options = with lib; {
    devbox.girl-technology = {
      domain = mkOption {
        type = types.string;
        default = "girl.technology";
        description = "The base domain to use for the girl-technology server";
      };

      port = mkOption {
        type = types.int;
        default = 3001;
        description = "The port to run the girl-technology server on.";
      };

      user = mkOption {
        type = types.string;
        default = "girl-technology";
      };

      group = mkOption {
        type = types.string;
        default = "girl-technology";
      };

      package = mkOption {
        type = types.package;
        default = perSystem.self.girl-technology-server;
        description = "The package to use for girl-technology. Should be the one included with this flake probably";
      };

      databaseName = mkOption {
        type = types.string;
        default = "girl.technology";
        description = "The PostgreSQL database to use as backing storage for the girl-technology server.";
      };
    };
  };

  config = {
    users = {
      users.${cfg.user} = {
        group = cfg.group;
        isSystemUser = true;
      };
      groups.${cfg.group} = { };
    };

    systemd.services."girl.technology" = {
      description = "Server for https://${cfg.domain}";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        DATABASE_URL = "postgres://${cfg.user}@127.0.0.1/${cfg.databaseName}";
        GIRL_TECHNOLOGY_MAIN_DOMAIN = cfg.domain;
        GIRL_TECHNOLOGY_PORT = toString cfg.port;
      };

      startLimitIntervalSec = 10;

      serviceConfig = {
        Restart = "always";
        RestartSec = "10s";

        WorkingDirectory = cfg.package;
        ExecStart = "${cfg.package}/bin/girl_technology_server";

        User = cfg.user;
        Group = cfg.group;
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ cfg.databaseName ];
      enableTCPIP = true;
      # Allow the given user to access the database w/o a password
      authentication = lib.mkOverride 10 ''
        # type database            DBUser      origin-address auth-method
        local  ${cfg.databaseName} ${cfg.user}                trust
        host   ${cfg.databaseName} ${cfg.user} 127.0.0.1/32   trust
        host   ${cfg.databaseName} ${cfg.user} ::1/128        trust
      '';
      initialScript = pkgs.writeText "girl-technology-db-initScript" ''
        CREATE ROLE ${cfg.user} WITH LOGIN CREATEDB;
      '';
    };

    services.nginx.enable = true;
    services.nginx.virtualHosts.${cfg.domain} = {
      forceSSL = true;

      locations."/" =
        let
          baseURL = "http://localhost:${toString cfg.port}";
        in
        {
          extraConfig = ''
            if ($sub = \'\') {
              proxy_pass ${baseURL};
            }
            proxy_pass ${baseURL}/category/$sub;
          '';
        };

      locations."/static/" = {
        alias = "${cfg.package}/static/dist/";
      };

      locations."/assets/" = {
        alias = "${cfg.package}/assets/";
      };
    };

    devbox.nginx.wildcard.domains.${cfg.domain}.enable = true;
  };
}
