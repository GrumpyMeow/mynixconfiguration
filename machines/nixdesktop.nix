{ config, pkgs, lib, ... }:

{
  nix.nixPath = [ "nixos-config=/root/mynixconfiguration/machines/nixdesktop.nix" ];

  imports = [ 
    <nixpkgs/nixos/modules/virtualisation/lxc-container.nix> 
    ../modules/desktop/plasma-desktop.nix
    ../modules/desktop/webbrowser.nix
    /root/mynixconfiguration/modules/headless/code-server.nix
  ];

  console.enable = true;

  systemd.services."getty@" = {
    unitConfig.ConditionPathExists = ["" "/dev/%I"];
  };
  
  nix.settings = {
    sandbox = false;
  };
  
  networking.enableIPv6 = false;
      
  programs.steam = {
    enable = true;
  }; 

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


  services.accounts-daemon.enable = lib.mkForce false;
  systemd.services.powerdevil = {
    wantedBy = lib.mkForce [];

    enable = false;
  };

  systemd.services.systemd-rfkill = {
    wantedBy = lib.mkForce [];
    enable = false;
  };

  systemd.services.udisks2 = {
    enable = false;
    wantedBy = lib.mkForce [];
  };
   
  environment.systemPackages = with pkgs; [
    #pkgs.chromium
    pkgs.vscode
    pkgs.trilium-desktop
    pkgs.bitwarden
  ];  
  
  system.stateVersion = "24.05";
}
