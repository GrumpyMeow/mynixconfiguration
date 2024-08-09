{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in

{  

  networking.firewall = {
    checkReversePath = "loose";
    interfaces.eth0 = {
      allowedTCPPorts = [ 3001 ];
    };
  };

  services.ntopng = {
    enable = true;
    httpPort = 3001;
    interfaces = [ "eth0" ];
    redis.createInstance = "ntopng";
    extraConfig = ''
      --disable-login=1
      --local-networks="${vars.subnet}=lan"
      --dns-mode=1
    '';    
  };
}
