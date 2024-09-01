{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in

{
  networking.firewall = {
    checkReversePath = "loose";
    interfaces.eth0 = {
      allowedUDPPorts = [ 53 ];
    };
  };

  services.unbound = {
    enable = true;
    checkconf = true;
    resolveLocalQueries = false;
    settings = {
      server = {
        interface = [ "127.0.0.1" vars.ip ];
        tls-system-cert = true;
        access-control = [
          "0.0.0.0/0 allow"
          "127.0.0.0/8 allow"
          "${vars.subnet} allow"
          "192.168.1.1/24 allow"
          "100.0.0.0/8 allow"
        ];

        prefer-ip6 = false;

        private-domain = [ vars.domain ]; # "local"
        private-address = [
          vars.subnet
        ];
        unblock-lan-zones = true;
        insecure-lan-zones = true;       
        log-queries = false;
        cache-min-ttl = 3600;
        cache-max-ttl = 86400;
        prefetch = true;
        num-threads = 2;
      

        local-zone = [
         ''"${vars.domain}." static''
         ''"${vars.publicDomain}." static''
         #''"local." static''
        ];
        local-data = [
          ''"${vars.domain}. IN A ${vars.ip}"''
          #''"local. A ${vars.ip}"''
          # .lan & .local (used for uptime pinging)
          ''"${vars.hostName}.${vars.domain}. A ${vars.ip}"''
          ''"${vars.mqttServerHostName}.${vars.domain}. A ${vars.ip}"''
          ''"hub.${vars.domain}. A ${vars.subnetPrefixIP}.2"''
          ''"ap-buiten.${vars.domain}. A ${vars.subnetPrefixIP}.3"''
          ''"ap-beneden.${vars.domain}. A ${vars.subnetPrefixIP}.4"''
          ''"ap-zolder.${vars.domain}. A ${vars.subnetPrefixIP}.5"''
          ''"ap-keuken.${vars.domain}. A ${vars.subnetPrefixIP}.6"''
          ''"nixsteam.${vars.domain}. A ${vars.subnetPrefixIP}.7"''
          ''"${vars.zabbixServerHostName}.${vars.domain}. A ${vars.zabbixServerIP}"''
          ''"opnsense.${vars.domain}. A ${vars.subnetPrefixIP}.22"''
          ''"immich.${vars.domain} A ${vars.subnetPrefixIP}.23"''
          ''"deurbel.${vars.domain}. A ${vars.subnetPrefixIP}.63"''
          ''"pve2.${vars.domain} A ${vars.subnetPrefixIP}.77"''
          ''"camvoortuin.${vars.domain}. A ${vars.subnetPrefixIP}.78"''
          ''"schuurdeurlamp.${vars.domain}. A ${vars.subnetPrefixIP}.79"''
          ''"e6510.${vars.domain} A ${vars.subnetPrefixIP}.88"''
          ''"HP15E25C.${vars.domain}. A ${vars.subnetPrefixIP}.91"''
          ''"soundbar-sander.${vars.domain} A ${vars.subnetPrefixIP}.92"''
          # ESPHome
          ''"washoklamp.${vars.domain}. A ${vars.subnetPrefixIP}.40"''
          ''"overlooplamp.${vars.domain}. A ${vars.subnetPrefixIP}.41"''
          ''"cv-ruimte.${vars.domain}. A ${vars.subnetPrefixIP}.42"''
          ''"badkamerlamp.${vars.domain}. A ${vars.subnetPrefixIP}.43"''
          ''"dsmr.${vars.domain}. A ${vars.subnetPrefixIP}.44"''
          ''"slaapkamerlamp.${vars.domain}. A ${vars.subnetPrefixIP}.45"''
          ''"zolderoverlooplamp.${vars.domain}. A ${vars.subnetPrefixIP}.46"''
          ''"voordeurslot.${vars.domain}. A ${vars.subnetPrefixIP}.47"''
          ''"tafellamp.${vars.domain}. A ${vars.subnetPrefixIP}.48"''
          ''"hub-schakelaar.${vars.domain}. A ${vars.subnetPrefixIP}.49"''
          ''"nachtlamp-sander.${vars.domain}. A ${vars.subnetPrefixIP}.50"''
          ''"voortuinlamp.${vars.domain}. A ${vars.subnetPrefixIP}.52"''
          ''"echo1.${vars.domain}. A ${vars.subnetPrefixIP}.54"''
          ''"floodlight.${vars.domain}. A ${vars.subnetPrefixIP}.55"''
          # *.933k.nl
          ''"zabbix.${vars.publicDomain}. A ${vars.reverseProxyIP}"''
          ''"vaultwarden.${vars.publicDomain}. A ${vars.reverseProxyIP2}"''
          ''"immich.${vars.publicDomain}. A ${vars.reverseProxyIP}"''
          ''"trilium.${vars.publicDomain}. A ${vars.reverseProxyIP2}"''
          ''"proxmox.${vars.publicDomain}. A ${vars.reverseProxyIP}"''
          ''"frigate.${vars.publicDomain}. A ${vars.reverseProxyIP2}"''
          ''"plex.${vars.publicDomain}. A ${vars.reverseProxyIP2}"''
          ''"jellyfin.${vars.publicDomain}. A ${vars.reverseProxyIP2}"''
          ''"torrent.${vars.publicDomain}. A ${vars.reverseProxyIP}"''
          ''"mail.${vars.publicDomain}. A ${vars.subnetPrefixIP}.97"''
          ''"opnsense.${vars.publicDomain}. A ${vars.reverseProxyIP}"''
          ''"router.${vars.publicDomain}. A ${vars.reverseProxyIP}"''
          ''"pve2.${vars.publicDomain}. A ${vars.reverseProxyIP}"''
          ''"esphome.${vars.publicDomain}. A ${vars.reverseProxyIP2}"''
          ''"zigbee2mqtt.${vars.publicDomain}. A ${vars.reverseProxyIP2}"''
          ''"ntopng.${vars.publicDomain}. A ${vars.reverseProxyIP}"''
          ''"${vars.publicDomain}. A ${vars.reverseProxyIP}"''
          ''"*.${vars.publicDomain}. A ${vars.reverseProxyIP}"''
        ];

      };

      forward-zone = [
        # { 
        #   name = ".";
        #   forward-addr = [
        #      "8.8.8.8"
        #      "8.8.4.4"
        #      "62.179.104.196"
        #      "213.46.228.196"
        #   ];
        # }
        {
          name = ".";	
          forward-tls-upstream = true;
          forward-addr = [
            "2620:fe::fe@853#quad9.net"
            "2606:4700:4700::1111@853#cloudflare-dns.com"
            "2001:4860:4860::8888@853#dns.google"
            "1.1.1.1@853#cloudflare-dns.com"
            "8.8.8.8@853:dns.google"
          ];
        }
        {
          name = "onion.";
        }
      ];

      remote-control.control-enable = false;
    };
  };

  environment.systemPackages = with pkgs; [
    traceroute dig
  ];
}

