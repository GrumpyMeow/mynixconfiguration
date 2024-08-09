{ config, lib, pkgs, ... }:

with lib;

let
    vars = import ../../vars.nix;
in

{
  services.timesyncd.enable = false;

  services.chrony = {
    enable = true;
    servers = vars.upstreamNTP;
    enableNTS = true;
    extraConfig = ''
      allow ${vars.subnet}
    '';
  };

  networking.firewall.allowedUDPPorts = [ 123 323 ];
}
