{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  

  networking.firewall = {
    checkReversePath = "loose";
    interfaces.eth0 = {
      allowedTCPPorts = [ 8080 ];
    };
  };

  services.trilium-server = {
    enable = true;
    port = 8080;
    noAuthentication = true;
    host = "0.0.0.0";
    dataDir = "/var/lib/trilium";
  };

  services.nginx = {
    enable = true;

    virtualHosts = {
      "trilium" = {
        useACMEHost = vars.publicDomain;
        http2 = true;
        serverName = "trilium.${vars.publicDomain}";
        forceSSL = true;
        extraConfig = ''
          send_timeout 100m;
          proxy_redirect off;
          proxy_buffering off;
        '';        
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
        };
      };

    };
  };

}
