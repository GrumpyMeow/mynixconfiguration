{ config, lib, pkgs, ... }:

with lib;

let
in
{  

  networking.firewall = {
    checkReversePath = "loose";
    interfaces.eth0 = {
      allowedTCPPorts = [ 8080 ];
    };
  };

  services.trilium-server = {
    enable = true;
    port = 8080;
    noAuthentication = true;
    host = "0.0.0.0";
    dataDir = "/var/lib/trilium";
  };
}
