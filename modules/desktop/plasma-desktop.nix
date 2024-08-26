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

#  services.xserver.enable = true;
  services.displayManager.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.displayManager.sddm.settings = {
    Autologin = {
      Session = "plasma.desktop";
      User = "system";
    };
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
