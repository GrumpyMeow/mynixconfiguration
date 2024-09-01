{ config, lib, pkgs, ... }:

with lib;
let
  vars = import ../../vars.nix;
in
{
  services.tailscale = {
    enable = true;
    interfaceName = "userspace-networking";
    port = 41641;
    openFirewall = true;
    useRoutingFeatures = "server";
    extraUpFlags = [       
    ];
    extraSetFlags = [
      "--accept-dns=false"
      "--advertise-exit-node"
      "--advertise-routes=${vars.subnet},${vars.upstreamSubnet}"       
      "--exit-node-allow-lan-access"
      "--update-check=false"
      "--webclient=false"
      "--ssh=false"
    ];
    extraDaemonFlags = [
      "--no-logs-no-support"
    ];
  };

  systemd.services.tailscaled.serviceConfig.LogLevelMax = 4; # https://www.ctrl.blog/entry/systemd-log-levels.html
}
