{ config, lib, pkgs, ... }:

with lib;

let

in

{

  services.zabbixAgent = {
    enable = true;
    server = "192.168.178.10";
    openFirewall = true;
    settings = {
      ServerActive = "192.168.178.10";
      AllowKey = "system.run[*]";
      AllowRoot = 1;
    };
  };

  environment.systemPackages = with pkgs; [

  ];  


}
