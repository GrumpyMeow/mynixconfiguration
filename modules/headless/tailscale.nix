{ config, lib, pkgs, ... }:

with lib;

let

in

{
  services.tailscale = {
    enable = true;
    interfaceName = "userspace-networking";
    port = 41641;
    openFirewall = true;
    useRoutingFeatures = "server";
    extraUpFlags = [ "--advertise-routes=${vars.subnet},192.168.1.0/24" "--advertise-exit-node" "--no-logs-no-support"];
  };

  systemd.services.tailscaled.serviceConfig.LogLevelMax = 4; # https://www.ctrl.blog/entry/systemd-log-levels.html

}
