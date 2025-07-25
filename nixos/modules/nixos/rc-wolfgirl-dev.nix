{
  config,
  lib,
  perSystem,
  ...
}:
let
  cfg = config.devbox.rc-wolfgirl-dev;
in
{
  imports = [ ./rc-secrets.nix ];

  options.devbox.rc-wolfgirl-dev = with lib; {
    enable = mkEnableOption "Whether to enable the RC server";
    package = mkOption {
      type = types.package;
      default = perSystem.rc-wolfgirl-dev.rc-crossposter;
      description = "The package to use to run the server. Should be a sanic binary accepting the standard flags/environment variables.";
    };

    staticPackage = mkOption {
      type = types.package;
      default = perSystem.rc-wolfgirl-dev.rc-crossposter-static;
      description = "The package containing the static files for the server.";
    };

    domain = mkOption {
      type = types.str;
      default = "rc.wolfgirl.dev";
      description = "The base domain to use for the RC server";
    };

    port = mkOption {
      type = types.int;
      default = 8000;
      description = "The port to run the RC server on.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services."rc.wolfgirl.dev" = {
      description = "Server for https://${cfg.domain}";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        RC_DATA_DIR = cfg.dataDir;
        SOPS_AGE_KEY_FILE = config.sops.secrets.rc_wolfgirl_dev_key.path;
      };

      startLimitIntervalSec = 10;

      serviceConfig = {
        Restart = "always";
        RestartSec = "10s";

        ExecStart = "${lib.getExe cfg.package} --port ${toString cfg.port}";

        User = cfg.user;
        Group = cfg.group;
      };
    };

    services.nginx.enable = true;
    services.nginx.appendHttpConfig = ''
      upstream rc_wolfgirl_dev {
        keepalive 300;
        server 127.0.0.1:${toString cfg.port};
      }

      map $remote_addr $for_addr {
        ~^[0-9.]+$        "for=$remote_addr";
        ~^[0-9A-Fa-f:.]+$ "for=\"[$remote_addr]\"";
        default           "for=unknown";
      }
    '';
    services.nginx.virtualHosts.${cfg.domain} = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://rc_wolfgirl_dev";
        proxyWebsockets = true;
        extraConfig = ''
          # Use faster proxying
          proxy_request_buffering   off;
          proxy_buffering           off;
          # Security measures for Sanic
          proxy_set_header          Forwarded "by=\"_${cfg.domain}\";$for_addr;proto=$scheme;host=\"$http_host\"";
          # Allow uploading large files
          client_max_body_size      100M;
        '';
      };

      # Just for authentication with ngx_http_auth_request_module
      locations."/auth".extraConfig = ''
        proxy_pass                  http://rc_wolfgirl_dev;
        proxy_pass_request_body     off;
        proxy_set_header            Content-Length "";
        proxy_set_header            X-Original-URI $request_uri;
        # Use faster proxying
        proxy_http_version          1.1;
        proxy_request_buffering     off;
        proxy_buffering             off;
        # Security measures for Sanic
        proxy_set_header            Forwarded "by=\"_${cfg.domain}\";$for_addr;proto=$scheme;host=\"$http_host\"";
      '';

      locations."/assets/" = {
        alias = "${cfg.staticPackage}/assets/";
        extraConfig = ''
          add_header      'Cache-Control' "public, max-age=60";
        '';
      };

      locations."/log_files/" = {
        alias = "${cfg.dataDir}/log_files/";
        extraConfig = ''
          auth_request    /auth;
          gzip            off;
        '';
      };

      extraConfig = ''
        error_page 401 = @goto_login;
        location @goto_login {
          return 301 /login?next=$request_uri;
        }
      '';
    };
  };
}
