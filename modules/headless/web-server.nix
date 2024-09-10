{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
   users.users.nginx.extraGroups = [ "acme" ];

   security.acme = {
     acceptTerms = true;
     defaults = {
      email = vars.acme.mailaddress;
      dnsProvider = "transip";
      dnsResolver = "ns1.transip.nl:53";
      dnsPropagationCheck = true;
      environmentFile = pkgs.writeText "transipEnvFile" ''
        TRANSIP_ACCOUNT_NAME = "${vars.acme.transipAccountName}"
        TRANSIP_PRIVATE_KEY_PATH = ${pkgs.writeText "transip_private_key" vars.acme.privateKey}
      '';
      enableDebugLogs = true;
     };
     certs."${vars.publicDomain}" = {
       domain = "*.${vars.publicDomain}";
       #domain = vars.publicDomain;
       extraDomainNames = [ "${vars.publicDomain}" ];
     };
   };

  services.nginx = {
    enable = true;
    resolver.ipv6 = false;
    # recommendedTlsSettings = true;
    # recommendedProxySettings = true;
    # recommendedGzipSettings = true;
    # recommendedOptimisation = true;
    # clientMaxBodySize = "300m";
    # logError = "stderr debug";

    # # Only allow PFS-enabled ciphers with AES256
    # sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
  };

  networking.firewall.allowedTCPPorts = [80 443 8123];

  # catch-all
  services.nginx.virtualHosts."_" = {
    useACMEHost = vars.publicDomain;
    forceSSL = true;
    default = true;
    locations."~ .*".return = "403";
  };

  # environment.persistence = {
  #   "/persist".directories = ["/var/lib/acme"];
  # };


  services.nginx.virtualHosts."proxmox" = {
    useACMEHost = vars.publicDomain;
    http2 = true;
    serverName = "proxmox.${vars.publicDomain}";
    forceSSL = true;
    extraConfig = ''
      send_timeout 100m;
      proxy_read_timeout 300;
      proxy_connect_timeout 300;
      proxy_send_timeout 300; 
      #proxy_redirect off;
      #proxy_buffering off;
    '';        
    locations."/" = {
      proxyPass = "https://192.168.1.5:8006";
      proxyWebsockets = true;
    };   
  };

  services.nginx.virtualHosts."immich" = {
    useACMEHost = vars.publicDomain;
    http2 = true;
    serverName = "immich.${vars.publicDomain}";
    forceSSL = true;
    extraConfig = ''
      send_timeout 100m;
      proxy_read_timeout 300;
      proxy_connect_timeout 300;
      proxy_send_timeout 300; 
      #proxy_redirect off;
      #proxy_buffering off;
    '';        
    locations."/" = {
      proxyPass = "http://immich.lan:2283";
      proxyWebsockets = true;
    };   
  };  

  services.nginx.virtualHosts."mail" = {
    useACMEHost = vars.publicDomain;
    http2 = true;
    serverName = "mail.${vars.publicDomain}";
    forceSSL = true;
    extraConfig = ''
      send_timeout 100m;
      proxy_read_timeout 300;
      proxy_connect_timeout 300;
      proxy_send_timeout 300; 
      #proxy_redirect off;
      #proxy_buffering off;
    '';        
    locations."/" = {
      proxyPass = "https://mail.lan:443";
      proxyWebsockets = true;
    };   
  };

  services.nginx.virtualHosts."zabbix" = {
    useACMEHost = vars.publicDomain;
    http2 = true;
    serverName = "zabbix.${vars.publicDomain}";
    forceSSL = true;
    extraConfig = ''
      send_timeout 100m;
      proxy_read_timeout 300;
      proxy_connect_timeout 300;
      proxy_send_timeout 300; 
      #proxy_redirect off;
      #proxy_buffering off;
    '';        
    locations."/" = {
      proxyPass = "http://zabbix.lan:8080";
      proxyWebsockets = true;
    };   
  };

  services.nginx.virtualHosts."homeassistant" = {
    useACMEHost = vars.publicDomain;
    http2 = true;
    serverName = "${vars.publicDomain}";
    listen = [{port = 8123;  addr="0.0.0.0"; ssl=true;}];
    forceSSL = true;
    extraConfig = ''
      proxy_buffering off;
    '';        
    locations."/" = {
      #proxyPass = "http://homeassistant.lan:8123/";
      proxyPass = "http://192.168.1.9:8123/";
      proxyWebsockets = true;
      extraConfig = ''
         proxy_set_header Upgrade $http_upgrade;
         proxy_set_header Connection $connection_upgrade;
      '';
    };   
  };

  services.nginx.virtualHosts."pve2" = {
    useACMEHost = vars.publicDomain;
    http2 = true;
    serverName = "pve2.${vars.publicDomain}";
    forceSSL = true;
    extraConfig = ''
      send_timeout 100m;
      proxy_read_timeout 300;
      proxy_connect_timeout 300;
      proxy_send_timeout 300; 
      #proxy_redirect off;
      #proxy_buffering off;
    '';        
    locations."/" = {
      proxyPass = "https://pve2.lan:8006";
      proxyWebsockets = true;
    };   
  };

  services.nginx.virtualHosts."pbs2" = {
    useACMEHost = vars.publicDomain;
    http2 = true;
    serverName = "pbs2.${vars.publicDomain}";
    forceSSL = true;
    extraConfig = ''
      send_timeout 100m;
      proxy_read_timeout 300;
      proxy_connect_timeout 300;
      proxy_send_timeout 300; 
      #proxy_redirect off;
      #proxy_buffering off;
    '';        
    locations."/" = {
      proxyPass = "https://pve2.lan:8007";
      proxyWebsockets = true;
    };   
  };


}
