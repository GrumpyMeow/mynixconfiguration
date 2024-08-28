{ config, pkgs, lib, ... }:

{
  nix.nixPath = [ "nixos-config=/root/mynixconfiguration/machines/nixdesktop.nix" ];

  imports = [ 
    <nixpkgs/nixos/modules/virtualisation/lxc-container.nix> 
    /root/mynixconfiguration/modules/headless/code-server.nix
  ];

  console.enable = true;

  systemd.services."getty@" = {
    unitConfig.ConditionPathExists = ["" "/dev/%I"];
  };
  
  nixpkgs.config = { 
    allowUnfree = true; 
  };
    
  nix.settings = {
    auto-optimise-store = true;
    sandbox = false;
  };
  
  system.autoUpgrade= {
    enable = true;
    allowReboot = true;
  };
  
  networking.enableIPv6 = false;
    
  services.desktopManager.plasma6.enable = true;
  services.xserver.enable = false;

  services.displayManager.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  
  programs.chromium.enable = true;
  programs.chromium.homepageLocation = "https://933k.nl:8123";
  programs.chromium.extraOpts = { 
    "BrowserSignin" = 0;
    "SyncDisabled" = true;
    "PasswordManagerEnabled" = false;
    "SpellcheckEnabled" = true;
    "SpellcheckLanguage" = [
      "nl"
      "en-US"
    ];
  };
  
  users.users.system = {
    isNormalUser = true;
    home = "/home/system";
    description = "System user";
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;
  };
  
  services.displayManager.sddm.settings = {
    Autologin = {
      Session = "plasma.desktop";
      User = "system";
    };
  };

  programs.steam = {
    enable=true;
  }; 

  services.pipewire.enable = true;

#  environment.sessionVariables = rec {
#    PULSE_SERVER = "tcp:192.168.178.2";
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
    pkgs.chromium
    pkgs.vscode
    pkgs.trilium-desktop
    pkgs.bitwarden
    pkgs.git
    pkgs.gh
  ];  
  
  system.stateVersion = "24.05";
}
