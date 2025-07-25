{ config, lib, ... }:
let
  cfg = config.devbox.pds;
in
{
  imports = [
    ./nginx-wildcard.nix
  ];

  options.devbox.pds = with lib; {
    enable = mkEnableOption "Whether to enable the Bluesky PDS";
    domain = mkOption {
      type = types.str;
      description = "Default domain for the Bluesky PDS";
      example = "girl.technology";
    };
  };

  config = lib.mkIf cfg.enable {
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
      forceSSL = true;

      locations."~ ^(/xrpc|/.well-known/atproto-did)" = {
        proxyPass = "http://localhost:${toString config.services.pds.settings.PDS_PORT}";
        proxyWebsockets = true;
        recommendedProxySettings = true;

      };
    };

    devbox.nginx.wildcard.domains.${cfg.domain}.enable = true;
  };
}
