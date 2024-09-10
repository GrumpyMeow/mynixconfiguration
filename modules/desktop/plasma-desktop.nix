{ config, lib, pkgs, ... }:

with lib;

let

in

{
  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };

  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = false;
  };

  environment.plasma6.excludePackages = [
    pkgs.kdePackages.elisa
    pkgs.kdePackages.khelpcenter
    pkgs.kdePackages.kwalletmanager
    pkgs.kdePackages.kwallet
    pkgs.kdePackages.kinfocenter
  ];

  services.displayManager.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      Autologin = {
        Session = "plasma.desktop";
        User = "system";
      };
    };
  };

  hardware.opengl = {
    enable = true;

    ## amdvlk: an open-source Vulkan driver from AMD
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  environment.systemPackages = with pkgs; [
    (pkgs.vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
      ];
    })
    pkgs.trilium-desktop
    pkgs.bitwarden
    pkgs.bitwarden-desktop
    pkgs.remmina
    pkgs.xdg-utils # for pkgs.gh
    pkgs.kcalc # KDE calculator
    #pkgs.libreoffice-qt6-fresh # Better for Plasma desktop
    #pkgs.hunspell # Spelling used by: LibreOffice
    #pkgs.hunspellDicts.nl_NL # Spelling used by: LibreOffice
    pkgs.pulseaudio    
    #pkgs.kdenlive
    #pkgs.ledger-live-desktop
    #pkgs.gimp
    #pkgs.mqttx

  ];  
  
}
