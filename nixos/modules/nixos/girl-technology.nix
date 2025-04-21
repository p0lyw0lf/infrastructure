{
  config,
  lib,
  ...
}:
let
  cfg = config.devbox.girl-technology;
in
{
  options = with lib; {
    devbox.girl-technology = {
      domain = mkOption {
        type = types.string;
        default = "girl.technology";
        description = "The base domain to use for the girl-technology server";
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
        description = "The package to use for girl-technology. Should be the one included with this flake probably";
      };
    };
  };

  config = {
    systemd.services."girl.technology" = {
      description = "Server for https://${cfg.domain}";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      startLimitIntervalSec = 10;

      serviceConfig = {
        Restart = "always";
        RestartSec = "10s";

        WorkingDirectory = cfg.package;
        ExecStart = "${cfg.package}/bin/girl_technology_server";
        # TODO: environment variables

        User = cfg.user;
        Group = cfg.group;

        # TODO: more hardening?
      };
    };
  };
}
