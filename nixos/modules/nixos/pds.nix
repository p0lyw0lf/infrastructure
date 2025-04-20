{ config, lib, ... }:
let
  cfg = config.devbox.pds;

  # Given a domain name, calculate the server_name alias for a wildcard
  wildcardAlias = domain: "~^(?<sub>.+)\\.${lib.strings.escape [ "." ] domain}$";
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
      serverAliases = [ (wildcardAlias cfg.domain) ];

      enableACME = true;
      forceSSL = true;

      locations."~ ^(/xrpc|/.well-known/atproto-did)" = {
        proxyPass = "http://localhost:${toString config.services.pds.settings.PDS_PORT}";
        proxyWebsockets = true;
        recommendedProxySettings = true;

      };
    };
  };
}
