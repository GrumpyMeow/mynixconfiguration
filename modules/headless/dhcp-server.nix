{ config, lib, pkgs, ... }:
with lib;
let
    vars = import ../../vars.nix;
in
{
  networking.firewall = {
    checkReversePath = "loose";
    interfaces.eth0 = {
      allowedUDPPorts = [ 67 ];
    };
  };

  services.kea = {
    dhcp-ddns.enable = false;

    dhcp4 = {
      enable = true;
      settings = {

        control-socket = {
          socket-name = "/run/kea/kea-dhcp4.socket";
          socket-type = "unix";
        };

        interfaces-config = {
          interfaces = [ "eth0" ];
        };

        lease-database = {
          name = "/var/lib/kea/dhcp4.leases";
          persist = true;
          type = "memfile";
          lfc-interval = 86400;
        };

        authoritative = true;
        #rebind-timer = 2000;
        #renew-timer = 1000;
        valid-lifetime = 86400;
        cache-threshold = 0.5;
        cache-max-age = 600;

        option-data = [
          {
            name = "domain-name-servers";
            data = vars.ip;
            always-send = true;
          }
          {
            name = "routers";
            data = vars.gateway;
          }
          {
            name = "domain-name";
            data = vars.domain;
          }
          {
            name = "broadcast-address";
            data = "${vars.subnetPrefixIP}.255";
          }
          {
            name = "time-servers";
            data = vars.timeServerIP;    
          }
        ];
        loggers = [
          {
            name = "kea-dhcp4";
            severity = "WARN";
            output_options = [
              {
                output = "stdout";
              }
            ];
          }          
        ];
        subnet4 = [
          {
            pools = [ { pool = "${vars.subnetPrefixIP}.1 - ${vars.subnetPrefixIP}.199"; } ];
            subnet = vars.subnet;
            id = 1;
            reservations = [
              # Infrastructure devices
              { hw-address = "BC:24:22:8B:6C:22"; ip-address = "${vars.subnetPrefixIP}.1"; hostname = "nixserver"; }
              { hw-address = "58:47:ca:71:f6:03"; ip-address = "${vars.subnetPrefixIP}.2"; hostname = "hub"; }
              { hw-address = "68:d7:9a:0b:16:80"; ip-address = "${vars.subnetPrefixIP}.3"; hostname = "ap-buiten"; }
              { hw-address = "d4:1a:d1:18:6b:fc"; ip-address = "${vars.subnetPrefixIP}.4"; hostname = "ap-beneden"; }
              { hw-address = "d4:1a:d1:18:87:78"; ip-address = "${vars.subnetPrefixIP}.5"; hostname = "ap-zolder"; }
              { hw-address = "d4:1a:d1:18:87:74"; ip-address = "${vars.subnetPrefixIP}.6"; hostname = "ap-keuken"; }
              { hw-address = "BC:24:11:8B:6C:16"; ip-address = "${vars.subnetPrefixIP}.7"; hostname = "nixdesktop"; }
              
              # Virtual servers
              { hw-address = "a2:8f:9e:1a:a9:e0"; ip-address = "${vars.subnetPrefixIP}.9"; hostname = "hass"; }
              { hw-address = "bc:24:11:6f:d2:6d"; ip-address = "${vars.subnetPrefixIP}.10"; hostname = "zabbix"; }
              { hw-address = "bc:24:11:ab:75:a1"; ip-address = "${vars.subnetPrefixIP}.21"; hostname = "torrent"; }
              { hw-address = "bc:24:11:3c:dd:eb"; ip-address = "${vars.subnetPrefixIP}.22"; hostname = "opnsense"; }
              { hw-address = "b2:10:7c:85:88:e4"; ip-address = "${vars.subnetPrefixIP}.23"; hostname = "immich"; }
              # ESPHome devices
              { hw-address = "78:21:84:4f:a7:18"; ip-address = "${vars.subnetPrefixIP}.40"; hostname = "washoklamp"; }
              { hw-address = "10:5a:17:7a:73:1a"; ip-address = "${vars.subnetPrefixIP}.41"; hostname = "overlooplamp"; }
              { hw-address = "f0:08:d1:c8:b6:d0"; ip-address = "${vars.subnetPrefixIP}.42"; hostname = "cv-ruimte"; }
              { hw-address = "78:21:84:4f:6d:1c"; ip-address = "${vars.subnetPrefixIP}.43"; hostname = "badkamerlamp"; }
              { hw-address = "80:7d:3a:72:57:05"; ip-address = "${vars.subnetPrefixIP}.44"; hostname = "dsmr"; }
              { hw-address = "d4:a6:51:ab:ca:6f"; ip-address = "${vars.subnetPrefixIP}.45"; hostname = "slaapkamerlamp"; }
              { hw-address = "84:e3:42:26:8e:11"; ip-address = "${vars.subnetPrefixIP}.46"; hostname = "zolderoverlooplamp"; }
              { hw-address = "dc:4f:22:f0:f6:a0"; ip-address = "${vars.subnetPrefixIP}.47"; hostname = "voordeur"; }
              { hw-address = "2c:f4:32:d8:8d:9d"; ip-address = "${vars.subnetPrefixIP}.48"; hostname = "tafellamp"; }
              { hw-address = "dc:4f:22:f0:ba:e7"; ip-address = "${vars.subnetPrefixIP}.49"; hostname = "hub-schakelaar"; }
              { hw-address = "84:e3:42:a4:19:6d"; ip-address = "${vars.subnetPrefixIP}.50"; hostname = "nachtlamp-sander"; }
              { hw-address = "98:cd:ac:75:27:68"; ip-address = "${vars.subnetPrefixIP}.51"; hostname = "esp32-a1s"; }
              { hw-address = "84:e3:42:e3:18:9e"; ip-address = "${vars.subnetPrefixIP}.52"; hostname = "voortuinlamp"; }
              { hw-address = "24:6f:28:79:b8:1c"; ip-address = "${vars.subnetPrefixIP}.53"; hostname = "beganegrond"; }
              { hw-address = "64:b7:08:82:b1:3c"; ip-address = "${vars.subnetPrefixIP}.54"; hostname = "echo1"; }
              { hw-address = "d4:a6:51:40:e2:e8"; ip-address = "${vars.subnetPrefixIP}.55"; hostname = "tuinspot"; }
              # Smarthome devices
              { hw-address = "68:a4:0e:08:12:22"; ip-address = "${vars.subnetPrefixIP}.60"; hostname = "afzuigkap"; }
              { hw-address = "c8:d7:78:39:7b:bf"; ip-address = "${vars.subnetPrefixIP}.61"; hostname = "vaatwasser"; }
              #{ hw-address = "7c:49:eb:b8:81:63"; ip-address = "${vars.subnetPrefixIP}.62"; hostname = "woonkamperlamp-1"; }
              { hw-address = "ec:71:db:d3:98:42"; ip-address = "${vars.subnetPrefixIP}.63"; hostname = "deurbel"; }
              { hw-address = "b0:2a:43:0f:ff:3d"; ip-address = "${vars.subnetPrefixIP}.64"; hostname = "nagelstudio-home-mini"; }
              { hw-address = "ac:67:84:12:30:ce"; ip-address = "${vars.subnetPrefixIP}.65"; hostname = "slaapkamer-nest-hub"; }
              { hw-address = "d4:f5:47:a9:36:14"; ip-address = "${vars.subnetPrefixIP}.66"; hostname = "zoe-nest-mini"; }
              { hw-address = "d4:f5:47:23:35:0d"; ip-address = "${vars.subnetPrefixIP}.67"; hostname = "levi-nest-mini"; }
              { hw-address = "44:07:0b:f1:98:16"; ip-address = "${vars.subnetPrefixIP}.68"; hostname = "werkpleksander-nest-mini"; }
              { hw-address = "bc:df:58:33:5f:4a"; ip-address = "${vars.subnetPrefixIP}.69"; hostname = "woonkamer-chromecast"; }
              { hw-address = "38:8b:59:5a:25:1a"; ip-address = "${vars.subnetPrefixIP}.70"; hostname = "woonkamer-home-hub"; }
              #{ hw-address = "7c:49:eb:b7:8d:62"; ip-address = "${vars.subnetPrefixIP}.71"; hostname = "woonkamerlamp-2"; }
              { hw-address = "68:a4:0e:1e:2f:9f"; ip-address = "${vars.subnetPrefixIP}.72"; hostname = "kookplaat"; }
              { hw-address = "24:6f:28:ae:10:40"; ip-address = "${vars.subnetPrefixIP}.73"; hostname = "wled-zoe"; }
              { hw-address = "a8:54:b2:0e:b1:53"; ip-address = "${vars.subnetPrefixIP}.75"; hostname = "woonkamer-televisie"; }
              #{ hw-address = "b4:e8:42:c1:62:dc"; ip-address = "${vars.subnetPrefixIP}.76"; hostname = "tuinlamp"; }
              { hw-address = "88:ae:dd:02:ba:76"; ip-address = "${vars.subnetPrefixIP}.77"; hostname = "pve2"; }
              { hw-address = "00:1e:95:6d:33:bd"; ip-address = "${vars.subnetPrefixIP}.78"; hostname = "camvoortuin"; }
              { hw-address = "18:de:50:ea:2e:1a"; ip-address = "${vars.subnetPrefixIP}.79"; hostname = "schuurdeurlamp"; }
              # Mobile devices
              { hw-address = "b0:35:b5:b6:4f:d7"; ip-address = "${vars.subnetPrefixIP}.80"; hostname = "iphonevansander"; }
              { hw-address = "88:64:40:98:73:49"; ip-address = "${vars.subnetPrefixIP}.81"; hostname = "iphonevanzoe-2"; }
              { hw-address = "f8:e5:ce:6c:ae:fd"; ip-address = "${vars.subnetPrefixIP}.82"; hostname = "iphonetanya"; }
              { hw-address = "e4:b2:fb:4c:be:6d"; ip-address = "${vars.subnetPrefixIP}.83"; hostname = "iphonelevi"; }
              { hw-address = "5c:91:75:af:77:61"; ip-address = "${vars.subnetPrefixIP}.84"; hostname = "ipadzoe"; } # nieuwe ipad
              { hw-address = "f4:4e:e3:aa:50:78"; ip-address = "${vars.subnetPrefixIP}.85"; hostname = "hp850g7"; }
              { hw-address = "e8:da:20:54:a8:a9"; ip-address = "${vars.subnetPrefixIP}.86"; hostname = "switch"; }
              { hw-address = "40:a3:cc:ad:82:fc"; ip-address = "${vars.subnetPrefixIP}.87"; hostname = "chromebook-levi"; }
              { hw-address = "00:6b:9e:06:15:f7"; ip-address = "${vars.subnetPrefixIP}.88"; hostname = "e6510"; }
              { hw-address = "3c:21:9c:be:c4:2c"; ip-address = "${vars.subnetPrefixIP}.89"; hostname = "chromebook-zoe"; }
              { hw-address = "e0:c2:64:34:91:ee"; ip-address = "${vars.subnetPrefixIP}.90"; hostname = "ONV411156";
                option-data = [
                  {
                    name = "routers";
                    data = "192.168.1.1";
                  }                  
                ];
              }
              { hw-address = "e0:70:ea:15:e2:5c"; ip-address = "${vars.subnetPrefixIP}.91"; hostname = "HP15E25C"; }
              { hw-address = "60:b6:06:33:9f:cf"; ip-address = "${vars.subnetPrefixIP}.92"; hostname = "soundbar-sander"; }
              # Other devices
              { hw-address = "bc:24:11:17:32:65"; ip-address = "${vars.subnetPrefixIP}.93"; hostname = "wyomingsatellite"; }
              { hw-address = "bc:24:11:f9:9b:d2"; ip-address = "${vars.subnetPrefixIP}.97"; hostname = "mail"; }
              # 
            ];
          }
        ];
      };
    };
  };

  services.kea.ctrl-agent = {
    enable = true;
    settings = {
      control-sockets = {
        dhcp4 = {
          socket-type = "unix";
          socket-name = "/run/kea/kea-dhcp4.socket";
        };
      };
    };
  };

}
