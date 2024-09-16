{ config, lib, pkgs, ... }:

let
  vars = import ../../vars.nix;
  cfg = config.zabbixAgent;
in

with lib;
{ 
  options = {
    zabbixAgent = {      
      hostName = mkOption {
         default = config.networking.hostName;
         type = lib.types.str;
      };
    };
  }; 

  config = {
    services.zabbixAgent = {
      enable = true;
      package = pkgs.unstable.zabbix64.agent2;
      server = "zabbix.lan,2001:1c00:2615:ce00::10";
      openFirewall = true;
      settings = {
        Hostname = cfg.hostName;
        ServerActive = "zabbix.lan:10051";
        AllowKey = "system.run[*]";
        #LogRemoteCommands = "1";
        #AllowRoot = 1;
        UserParameter = "WAN.IP.address,curl -s ipinfo.io/ip";
        "Plugins.MQTT.Sessions.mqttlan.Url" = "tcp://mqtt.lan:1883";
        "Plugins.MQTT.Sessions.mqttlan.Topic" = "$SYS/broker/clients/#";
      };
    };
  };
}
