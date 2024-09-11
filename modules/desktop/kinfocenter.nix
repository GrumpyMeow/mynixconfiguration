{ config, lib, pkgs, ... }:

with lib;

let

in

{
  environment.systemPackages = with pkgs; [
    pkgs.kdePackages.kinfocenter
    
    # Packages needed for Info Center tool
    pkgs.pciutils
    pkgs.clinfo
    pkgs.gpu-viewer
    pkgs.wayland-utils
    pkgs.glxinfo
    pkgs.vulkan-tools
    pkgs.aha
    pkgs.fwupd
  ];  
  
  systemd.packages = [ pkgs.fwupd ];
  services.fwupd.enable = true;
}
