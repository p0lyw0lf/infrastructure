{ config, lib, ... }:
let
  cfg = config.devbox.rc-wolfgirl-dev;
in
{
  options.devbox.rc-wolfgirl-dev = with lib; {
    user = mkOption {
      type = types.str;
      default = "rc-wolfgirl-dev";
    };

    group = mkOption {
      type = types.str;
      default = "rc-wolfgirl-dev";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/rc-wolfgirl-dev";
      description = "The data directory for placing persistent files";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users."${cfg.user}" = {
      description = "rc.wolfgirl.dev service user";
      isSystemUser = true;
      group = "${cfg.group}";
      home = cfg.dataDir;
    };
    users.groups."${cfg.group}" = { };

    systemd.tmpfiles.settings."10-rc-wolfgirl-dev".${cfg.dataDir}.d = {
      inherit (cfg) user group;
    };

    sops.secrets.rc_wolfgirl_dev_key = {
      mode = "0440";
      group = cfg.group;
    };
  };
}
