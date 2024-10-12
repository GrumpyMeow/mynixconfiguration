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

  systemd.services.mosquitto.serviceConfig.LimitNOFILE = 99999;
  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "8192";
  }];

  
  services.mosquitto = {
    enable = true;
    logDest = [ "stdout" ];
    logType = [ "warning" ]; 
    settings = {
      sys_interval = 10;
      max_inflight_messages = 0;

    };
    listeners = [
      {
        port = vars.mqttPort;
        settings = {
          allow_anonymous = true;
          max_connections = -1;    
        };
        omitPasswordAuth = true;
        acl = [
            "pattern readwrite #"
            "pattern readwrite $SYS/#"
          ];
      }
    ];

  };

}
