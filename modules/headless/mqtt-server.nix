{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{
  networking.firewall = {
    checkReversePath = "loose";
    interfaces.eth0 = {
      allowedTCPPorts = [ vars.mqttPort ];
    };
  };

  
  services.mosquitto = {
    enable = true;
    logDest = [ "stdout" ];
    logType = [ "warning" ]; 
    listeners = [
      {
        port = vars.mqttPort;
        settings = {
          allow_anonymous = true;
        };
        omitPasswordAuth = true;
        acl = [ "pattern readwrite #" ];
      }
    ];

  };

}
