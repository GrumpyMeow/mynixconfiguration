{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{
  networking.firewall = {
    checkReversePath = "loose";
    interfaces.eth0 = {
      allowedTCPPorts = [ 6052 ];
    };
  };
  
  services.esphome = {
    enable = true;
    openFirewall = true;
    address = "0.0.0.0";
    package = pkgs.unstable.esphome;
  };

  services.nginx = {
    enable = true;

    virtualHosts = {
      "esphome" = {
        useACMEHost = vars.publicDomain;
        http2 = true;
        serverName = "esphome.${vars.publicDomain}";
        forceSSL = true;
        extraConfig = ''
          send_timeout 100m;
          proxy_redirect off;
          proxy_buffering off;
        '';        
        locations."/" = {
          proxyPass = "http://127.0.0.1:6052";
          proxyWebsockets = true;
        };
      };

    };
  };


}
