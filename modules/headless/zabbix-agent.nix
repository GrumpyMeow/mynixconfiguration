{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
  services.zabbixAgent = {
    enable = true;
    server = vars.zabbixServerIP;
    openFirewall = true;
    settings = {
      Hostname = "${vars.hostName}.${vars.domain}";
      ServerActive = vars.zabbixServerIP;
      AllowKey = "system.run[*]";
      AllowRoot = 1;
    };
  };

  
  # environment.systemPackages = [ 
  #   pkgs.zabbix.agent2
  # ];


}
