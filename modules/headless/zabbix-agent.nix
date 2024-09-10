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
      server = "zabbix.lan,2001:1c00:2615:ce00:be24:11ff:fe6f:d26d,fd3f:f41d:8489:0:be24:11ff:fe6f:d26d,2001:1c00:2623:ca00:be24:11ff:fe6f:d26d";
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
