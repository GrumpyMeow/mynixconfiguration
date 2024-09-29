{ config, pkgs, ... }:
let
  vars = import ../vars.nix;
in
{
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/sander/mynixconfiguration/machines/e6510.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
#    "/home/sander/.nix-defexpr/channels"
  ];


  imports =
    [ 
      ./e6510/hardware-configuration.nix
      ../modules/headless/zabbix-agent.nix
      ../modules/hardware/hp4100-printer.nix    
      ../modules/desktop/printer-scanner.nix
      ../modules/headless/clamav.nix
      ../modules/desktop/plasma-desktop.nix
      ../modules/desktop/kinfocenter.nix
      ../modules/desktop/webbrowser.nix
      ../modules/headless/generic.nix
    ];

  zabbixAgent.hostName = "e6510.${vars.domain}"; 

  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
      };
    };
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "e6510"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  services.xserver.videoDrivers = [
    "amdgpu"
    "radeon"
  ];

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable autodiscovery of network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound.
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.users.tanya = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.users.sander = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "network" "render" ];
    packages = with pkgs; [
      # chromium
      remmina
      partition-manager
      kate
      trilium-desktop
      vlc
      fdupes
    ];
  };

  environment.systemPackages = with pkgs; [
    remmina
    thunderbird
    kate
    partition-manager

    libreoffice-qt
    hunspell
    hunspellDicts.nl_NL

    dpkg
    cifs-utils
    fclones
    dupeguru
    libsForQt5.kdevelop
    libsForQt5.kdevelop-pg-qt
    cmake
    qt6.qtwebsockets
    libsForQt5.qt5.qtwebsockets
    cura
    obs-studio
    blender
    isoimagewriter
    usbutils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  }

  system.stateVersion = "23.05";

}

