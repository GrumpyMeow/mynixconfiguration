{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in

{  
  networking.firewall = {
    checkReversePath = "loose";
    interfaces.eth0 = {
      allowedTCPPorts = [ 8099 ];
    };
  };

  users.users.zigbee2mqtt.extraGroups = [ "lp" "dialout" "uucp" "tty" "wheel" ];

  services.zigbee2mqtt = {
    enable = true;    
    settings = {
      homeassistant = true;
      permit_join = false;
      mqtt = {
        server = "mqtt://${vars.mqttServerHostName}.${vars.domain}:${toString vars.mqttPort}";
      };
      serial = {
        port = "/dev/serial/by-id/usb-Silicon_Labs_CP2102N_USB_to_UART_Bridge_Controller_46541a0ee993eb1198edb15b3d98b6d1-if00-port0";
        adapter = "zstack";
        disable_led = true;
      };
      frontend = {
        port = 8099;
        host = "0.0.0.0";
      };

      advanced = {
        network_key = [
          152
          92
          186
          240
          164
          100
          230
          229
          48
          33
          144
          147
          102
          91
          194
          0
        ];
        pan_id = 44747;
        ext_pan_id = [
          145
          27
          40
          11
          219
          223
          178
          222
        ];
        homeassistant_legacy_entity_attributes = false;
        legacy_api = false;
        legacy_availability_payload = false;
        channel = 25;
        log_level = "info";
      };
      devices = {
        "0x00158d000413fa40" = {
          friendly_name = "Bewegingssensor zolder";
        };
        "0x00158d000346684c" = {
          friendly_name = "Bewegingssensor opslagkamer";
        };
        "0x00158d0006332e6d" = {
          friendly_name = "Rookmelder zolder";
        };
        "0x540f57fffef9b9fd" = {
          friendly_name = "Verwarming slaapkamer Levi";
        };
        "0x14b457fffe6f822b" = {
          friendly_name = "Slaapkamerlampen Zoe bediening";
        };
        "0x00124b002247e274" = {
          friendly_name = "Bewegingssensor overloop";
        };
        "0xbc33acfffe280835" = {
          friendly_name = "Slaapkamerlampen bedbediening";
        };
        "0x00158d0007ed43f9" = {
          friendly_name = "Bewegingssensor washok";
        };
        "0xa4c13805b29fec74" = {
          friendly_name = "Voordeursensor";
        };
        "0x000d6ffffe199c5c" = {
          friendly_name = "Werkpleklamp Sander";
        };
        "0x000d6ffffe1766b3" = {
          friendly_name = "Ganglamp kids";
        };
        "0xccccccfffe90d872" = {
          friendly_name = "Opslagkamerlamp 1";
        };
        "0x000d6ffffe1a5b15" = {
          friendly_name = "Opslagkamerlamp 2";
        };
        "0xd0cf5efffee5266e" = {
          friendly_name = "Slaapkamerlamp Levi 1";
        };
        "0x000d6ffffe16584c" = {
          friendly_name = "Slaapkamerlamp Levi 2";
        };
        "0x000d6ffffe187fef" = {
          friendly_name = "Slaapkamerlamp Levi 3";
        };
        "0xccccccfffe965725" = {
          friendly_name = "Slaapkamerlamp Levi 4";
        };
        "0xbc33acfffe280e5d" = {
          friendly_name = "Slaapkamerlampen Levi bedbediening";
        };
        "0xccccccfffe90d0fc" = {
          friendly_name = "Slaapkamerlamp Zoe 1";
        };
        "0xd0cf5efffef12c8a" = {
          friendly_name = "Slaapkamerlamp Zoe 2";
        };
        "0xd0cf5efffef29811" = {
          friendly_name = "Slaapkamerlamp Zoe 3";
        };
        "0x000d6ffffe1a636d" = {
          friendly_name = "Slaapkamerlamp Zoe 4";
        };
        "0x680ae2fffe12303a" = {
          friendly_name = "Slaapkamerlampen Zoe bedbediening";
        };
        "0x003c84fffef96fd2" = {
          friendly_name = "Badkamer verwarming";
        };
        "0xb4e3f9fffec6b634" = {
          friendly_name = "Woonkamer kastlamp 1";
        };
        "0xb4e3f9fffee16112" = {
          friendly_name = "Woonkamer kastlamp 2";
        };
        "0xa4c1383a40a67d43" = {
          friendly_name = "Keukenlamp";
          homeassistant= {};
          legacy = false ;
          optimistic = false;
          transition =  0;
          state_action = true;
        };
        "0x00124b002247e562" = {
          friendly_name = "Bewegingsensor gang";
        };
        "0xccccccfffe9659f8" = {
          friendly_name = "Ganglamp 1";
        };
        "0x000d6ffffe1624ed" = {
          friendly_name = "Ganglamp 2";
        };
        "0xa4c1387dcaeda1a0" = {
          friendly_name = "Watersensor washok";
        };
        "0x804b50fffe4468e4" = {
          friendly_name = "Verwarming slaapkamer Zoe";
        };
        "0xbc33acfffe15a97b" = {
          friendly_name = "Woonkamerlampen bediening";
        };
        "0xa4c1385eb99af5db" = {
          friendly_name = "Openslaande deur";
        };
        "0x2c1165fffe9b9752" = {
          friendly_name = "Woonkamerlamp bankhoek";
          transition = 30;
        };
        "0x2c1165fffe63b203" = {
          friendly_name = "Nachtlamp Zoë";
          transition = 5;
        };
        "0x14b457fffe6c6567" = {
          friendly_name = "Slaapkamerlampen Levi bediening";
        };
        "0xa4c138a415b82a70" = {
          friendly_name = "Alarm knop 1";
        };
        "0xa4c13824bf33290a" = {
          friendly_name = "Alarm knop 2";
        };
      };
      groups = {
        "1" = {
          friendly_name = "opslagkamerlampen";
          devices = [ "0xccccccfffe90d872/1" "0x000d6ffffe1a5b15/1" ];
        };
        "2" = {
          friendly_name = "slaapkamerlampen levi";
          devices = [ "0xd0cf5efffee5266e/1" "0x000d6ffffe16584c/1" "0x000d6ffffe187fef/1" "0xccccccfffe965725/1" ];
        };
        "3" = {
          friendly_name = "slaapkamerlampen zoe";
          devices = [ "0xccccccfffe90d0fc/1" "0xd0cf5efffef12c8a/1" "0xd0cf5efffef29811/1" "0x000d6ffffe1a636d/1" ];
        };
        "4" = {
          friendly_name = "woonkamer kastlampen";
          devices = [ "0xb4e3f9fffec6b634/1" "0xb4e3f9fffee16112/1" ];
        };
        "5" = {
          friendly_name= "ganglampen";
          devices = [ "0xccccccfffe9659f8/1" "0x000d6ffffe1624ed/1" ];
        };
      };

    };    
  };

  services.nginx = {
    enable = true;

    virtualHosts = {
      "zigbee2mqtt" = {
        useACMEHost = vars.publicDomain;
        http2 = true;
        serverName = "zigbee2mqtt.${vars.publicDomain}";
        forceSSL = true;
        extraConfig = ''
          send_timeout 100m;
          proxy_redirect off;
          proxy_buffering off;
        '';        
        locations."/" = {
          proxyPass = "http://127.0.0.1:8099";
          proxyWebsockets = true;
        };
      };

    };
  };
}
