{
  config,
  lib,
  perSystem,
  ...
}:
let
  cfg = config.devbox.bot-crossposter;
  rc-cfg = config.devbox.rc-wolfgirl-dev;
in
{
  imports = [ ./rc-secrets.nix ];

  options.devbox.bot-crossposter = with lib; {
    package = mkOption {
      type = types.package;
      default = perSystem.rc-wolfgirl-dev.bot-crossposter;
      description = "The package to use to run the crossposter bot.";
    };
  };

  config = {
    systemd.services."bot-crossposter" = {
      description = "Crossposter bot";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        RC_DATA_DIR = rc-cfg.dataDir;
        SOPS_AGE_KEY_FILE = config.sops.secrets.rc_wolfgirl_dev_key.path;
      };

      startLimitIntervalSec = 10;

      serviceConfig = {
        Restart = "always";
        RestartSec = "10s";

        ExecStart = lib.getExe cfg.package;

        User = rc-cfg.user;
        Group = rc-cfg.group;
      };
    };
  };
}
