{
  config,
  lib,
  perSystem,
  pkgs,
  ...
}:
let
  cfg = config.devbox.dotl-bud;
in
{
  options.devbox.dotl-bud = with lib; {
    enable = mkEnableOption "Whether to enable the DotL Bud bot";
    package = mkOption {
      type = types.package;
      default = perSystem.dotl-bud.dotl-bud-bin;
      description = "The package to use to run the crossposter bot.";
    };

    dbPackage = mkOption {
      type = types.package;
      default = perSystem.dotl-bud.dotl-bud-db;
      description = "The package containing all the non-Python data files necessary to run the bot";
    };

    user = mkOption {
      type = types.str;
      default = "dotl-bud";
    };

    group = mkOption {
      type = types.str;
      default = "dotl-bud";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/dotl-bud";
      description = "The data directory for placing persistent files";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users."${cfg.user}" = {
      description = "DotL Bud service user";
      isSystemUser = true;
      group = "${cfg.group}";
      home = cfg.dataDir;
    };
    users.groups."${cfg.group}" = { };

    systemd.tmpfiles.settings."10-dotl-bud".${cfg.dataDir}.d = {
      inherit (cfg) user group;
    };

    sops.secrets.dotl_bud_oauth_token = {
      mode = "0440";
      group = cfg.group;
    };

    systemd.services."dotl-bud" = {
      description = "DotL Bud discord bot";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        DB_DIRECTORY = cfg.dataDir;
        BAD_WORD_LIST = cfg.dataDir + "/filter/bad_word_list";
        BAD_WORD_REPLACE = cfg.dataDir + "/filter/bad_word_replace";
        OAUTH_TOKEN_FILE = config.sops.secrets.dotl_bud_oauth_token.path;
      };

      startLimitIntervalSec = 10;

      serviceConfig = {
        Restart = "always";
        RestartSec = "10s";

        ExecStart = pkgs.writeShellScript "dotl-bud-wrapper" ''
          for folder in db filter help perms; do
            if [ ! -d ${cfg.dataDir}/$folder ]; then
              cp -R ${cfg.dbPackage}/$folder ${cfg.dataDir}/$folder
            fi
          done
          chmod -R +w ${cfg.dataDir}

          ${lib.getExe cfg.package}
        '';

        User = cfg.user;
        Group = cfg.group;
      };
    };
  };
}
