{
  config,
  lib,
  pkgs,
  perSystem,
  ...
}:
let
  cfg = config.devbox.girl-technology;
  databaseName = if cfg.databaseName == null then cfg.user else cfg.databaseName;
in
{
  imports = [
    ./nginx-wildcard.nix
  ];

  options = with lib; {
    devbox.girl-technology = {
      domain = mkOption {
        type = types.str;
        default = "girl.technology";
        description = "The base domain to use for the girl-technology server";
      };

      port = mkOption {
        type = types.int;
        default = 3001;
        description = "The port to run the girl-technology server on.";
      };

      user = mkOption {
        type = types.str;
        default = "girl-technology";
      };

      group = mkOption {
        type = types.str;
        default = "girl-technology";
      };

      package = mkOption {
        type = types.package;
        default = perSystem.self.girl-technology-server;
        description = "The package to use for girl-technology. Should be the one included with this flake probably";
      };

      databaseName = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The PostgreSQL database to use as backing storage for the girl-technology server. Defaults to the username.";
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
        DATABASE_URL = "postgres://${cfg.user}@127.0.0.1/${databaseName}";
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
      enableTCPIP = true;
      # Allow the given user to access the database w/o a password
      authentication = ''
        # type database        DBUser      origin-address auth-method
        host   ${databaseName} ${cfg.user} 127.0.0.1/32   trust
        host   ${databaseName} ${cfg.user} ::1/128        trust
        host   postgres        ${cfg.user} 127.0.0.1/32   trust
        host   postgres        ${cfg.user} ::1/128        trust
      '';
      # TODO: this doesn't seem to be completely idempotent, I ended up needing
      # to run these commands manually during debugging. However! It seems to
      # work now at least :)
      initialScript =
        pkgs.writeText "girl-technology-db-initScript" ''
          CREATE ROLE "${cfg.user}" WITH LOGIN CREATEDB;
          CREATE DATABASE "${cfg.user}";
          GRANT ALL PRIVILEGES ON DATABASE "${cfg.user}" TO "${cfg.user}";
          ALTER DATABASE "${cfg.user}" OWNER TO "${cfg.user}";
        ''
        + (
          if cfg.user != databaseName then
            ''
              CREATE DATABASE "${databaseName}";
              GRANT ALL PRIVILEGES ON DATABASE "${databaseName}" TO "${cfg.user}";
              ALTER DATABASE "${databaseName}" OWNER TO "${cfg.user}";
            ''
          else
            ""
        );
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
            if ($sub = ''') {
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
