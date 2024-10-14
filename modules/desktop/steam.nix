{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{       
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  }; 

#  hardware.graphics = {
    ## radv: an open-source Vulkan driver from freedesktop
#    driSupport = true;

    ## amdvlk: an open-source Vulkan driver from AMD
#    extraPackages = [ pkgs.amdvlk ];
#    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
#  };
  
}
