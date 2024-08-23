{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in

{  

  networking.firewall = {
    checkReversePath = "loose";
    interfaces.eth0 = {
      allowedTCPPorts = [ 8222 ];
    };
  };

  fileSystems."/data/vaultwarden/backup" = {
    device = "//hub.${vars.domain}/backup/vaultwarden"; 
    fsType = "cifs";
    options = [      
      "nofail"
      "noauto"
      "rw"
      "rsize=16777216"
      "cache=loose"
      "x-systemd.after=network.target"
    ];
  };


  services.vaultwarden = {
    enable = true;
    backupDir = "/data/vaultwarden/backup";
    config = {
      DOMAIN = "https://vaultwarden.${vars.publicDomain}";
      WEBSOCKET_ENABLED = "true";

      SENDS_ALLOWED = false;
      SIGNUPS_ALLOWED = false;
      SIGNUPS_DOMAINS_WHITELIST = vars.publicDomain;
      INVITATIONS_ALLOWED = "false";
      SHOW_PASSWORD_HINT = "false";

      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;

      SMTP_HOST = "${vars.subnetPrefixIP}.97";
      SMTP_FROM = "vaultwarden@${vars.publicDomain}";
      SMTP_FROM_NAME = "Vaultwarden";
      SMTP_PORT = "25";
      SMTP_TIMEOUT = "15";
      SMTP_SSL = false;
      SMTP_SECURITY = "off";
      HELO_NAME = vars.publicDomain;
      SMTP_DEBUG = false;

      ADMIN_TOKEN = vars.vaultwardenToken;

      LOG_LEVEL = "warn";
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts = {
      "vaultwarden" = {
        useACMEHost = vars.publicDomain;
        http2 = true;
        serverName = "vaultwarden.${vars.publicDomain}";
        forceSSL = true;
        extraConfig = ''
          send_timeout 100m;
          proxy_redirect off;
          proxy_buffering off;
        '';        
        locations."/" = {
          proxyPass = "http://127.0.0.1:8222";
          proxyWebsockets = true;
        };
      };

    };
  };

}
