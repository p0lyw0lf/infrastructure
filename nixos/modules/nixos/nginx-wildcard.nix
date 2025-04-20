# Module that enables a wildcard domain for a given nginx host, with certificate
# renewal provided by porkbun instead of nginx.
{ config, lib, ... }:
let
  cfg = config.devbox.nginx.wildcard;
  wildcardAlias = domain: "~^(?<sub>.+)\\.${lib.strings.escape [ "." ] domain}$";
in
{
  options = with lib; {
    devbox.nginx.wildcard = {
      domains = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              enable = mkEnableOption "Enable wildcard access for the given domain";
            };
          }
        );
        default = { };
        example = literalExpression ''
          {
            devbox.nginx.wildcard.domains."girl.technology".enable = true;
          }
        '';
      };
    };
  };
  config = {
    sops.secrets.porkbun_env = { };

    services.nginx.virtualHosts =
      with lib;
      mapAttrs (
        domainName: domainConfig:
        mkIf domainConfig.enable {
          serverAliases = [ (wildcardAlias domainName) ];
          useACMEHost = domainName;
        }
      ) cfg.domains;

    security.acme.certs =
      with lib;
      mapAttrs (
        domainName: domainConfig:
        mkIf domainConfig.enable {
          domain = "*.${domainName}";
          extraDomainNames = [ domainName ];

          dnsProvider = "porkbun";
          environmentFile = config.sops.secrets.porkbun_env.path;

          group = config.services.nginx.group;
        }
      ) cfg.domains;
  };
}
