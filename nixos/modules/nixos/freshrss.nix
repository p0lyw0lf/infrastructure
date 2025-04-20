{ config, lib, ... }:
let
  cfg = config.devbox.freshrss;
in
{
  options.devbox.freshrss = with lib; {
    domain = mkOption {
      type = types.str;
      description = "Default domain for FreshRSS";
      example = "reshrss.wolfgirl.dev";
    };
  };

  config = {
    sops.secrets.freshrss_password = {
      # Allow the freshrss user to read this file
      mode = "0440";
      group = config.users.users.${config.services.freshrss.user}.group;
    };

    services.freshrss = {
      enable = true;

      defaultUser = "polywolf";
      passwordFile = config.sops.secrets.freshrss_password.path;

      baseUrl = "https://${cfg.domain}";

      virtualHost = cfg.domain;
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      enableACME = true;
      forceSSL = true;
    };
  };
}
