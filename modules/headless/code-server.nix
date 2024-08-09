{ config, lib, pkgs, ... }:
with lib;
let
in
{
  networking.firewall = {
    checkReversePath = "loose";
    interfaces.eth0 = {
      allowedTCPPorts = [ 3000 ];
    };
  };

  services.openvscode-server = {
    enable = true;
    port = 3000;
    host = "0.0.0.0";
    withoutConnectionToken = true;
    user = "root";
    group = "root";
  };
}
