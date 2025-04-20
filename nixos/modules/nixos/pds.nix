{ config, lib, ... }:
let
  cfg = config.devbox.pds;

  # Given a domain name, calculate the server_name directive
  serverName =
    domain:
    let
      escaped = lib.strings.escape [ "." ] domain;
    in
    "${domain} ~^(?<sub>.+)\\.${escaped}$";
in
{
  options.devbox.pds = with lib; {
    domain = mkOption {
      type = types.str;
      description = "Default domain for the BlueSky PDS";
      example = "girl.technology";
    };
  };

  config = {
    sops.secrets.pds_env = {
      mode = "0440";
      group = config.users.users.pds.group;
    };

    services.pds = {
      enable = true;

      environmentFiles = [
        config.sops.secrets.pds_env.path
      ];

      settings = {
        PDS_HOSTNAME = cfg.domain;
      };
    };

    services.nginx.enable = true;
    services.nginx.virtualHosts.${cfg.domain} = {
      serverName = serverName cfg.domain;

      enableACME = true;
      forceSSL = true;

      locations."~ ^(/xrpc|/.well-known/atproto-did)" = {
        proxyPass = "http://localhost:${config.services.pds.settings.PDS_PORT}";
        proxyWebsockets = true;
        recommendedProxySettings = true;

      };
    };
  };
}
