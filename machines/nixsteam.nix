{ config, pkgs, lib, ... }:
let
    vars = import ../vars.nix;
in
{
  imports = [ 
    <nixpkgs/nixos/modules/virtualisation/lxc-container.nix> 
    ../modules/desktop/plasma-desktop.nix
    ../modules/desktop/webbrowser.nix
    ../modules/headless/zabbix-agent.nix
    ../modules/headless/code-server.nix
    ../modules/desktop/steam.nix
    ../modules/desktop/iptv.nix
    ../modules/hardware/hp4100-printer.nix    
    ../modules/desktop/printer-scanner.nix
    ../modules/headless/generic.nix
  ];

  zabbixAgent.hostName = "nixsteam.${vars.domain}";

  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
      };
    };
  };

  console.enable = true;

  systemd.services."getty@" = {
    unitConfig.ConditionPathExists = ["" "/dev/%I"];
  };
  
  nix.settings = {
    sandbox = false;
  };

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/system/mynixconfiguration/machines/nixsteam.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
    
  networking.enableIPv6 = false;
  networking.hostName = "nixsteam";
      
  services.pipewire.enable = true;

#  environment.sessionVariables = rec {
#    PULSE_SERVER = "tcp:hub.lan";
#  }; 
  #hardware.pulseaudio.enable = true;
#  sound.enable = true;

  services.pipewire.pulse.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.wireplumber.enable = true;
  services.pipewire.audio.enable = true;


#  powerManagement.enable = lib.mkForce false;
  services.accounts-daemon.enable = lib.mkForce false;
#  systemd.services.powerdevil = {
#    wantedBy = lib.mkForce [];
#    enable = false;
#  };

#  systemd.services.systemd-rfkill = {
#    wantedBy = lib.mkForce [];
#    enable = false;
#  };

#  services.udisks2.enable = lib.mkForce false;
#  systemd.services.udisks2 = {
#    enable = false;
#    wantedBy = lib.mkForce [];
#  };
   
  environment.systemPackages = with pkgs; [
    pkgs.git
    pkgs.gh    
  ];  

  system.stateVersion = "24.11";
}

# Disable System Tray widgets
# Bottom-right, expand "Status and Notifications" panel, click "Configure System Tray".
# Disable: "Brightness and Color"
# Disable: "Disks & Devices"
# Disable: "Camera Indicator"
# Disable: "Power and Battery"

# Disable Screen locking
# System Settings > Screen locking > Lock screen automatically = Never

# Audio via 2nd HDMI port
# Select Profile "Pro Audio". Also "Pro Audio" for the other playback devices. Select "Playback Device" which displays "Philips Soundbar" as popup.

# Blinking screen during game-play, monitor loses sync
# Display Configuration, Select "Never" for "Adaptive Sync"
