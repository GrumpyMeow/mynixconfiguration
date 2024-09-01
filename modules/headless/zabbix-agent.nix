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
      server = vars.zabbixServerIP;
      openFirewall = true;
      settings = {
        Hostname = cfg.hostName;
        ServerActive = vars.zabbixServerIP;
        AllowKey = "system.run[*]";
        #AllowRoot = 1;
      };
    };
  };
}
