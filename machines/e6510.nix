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
<<<<<<< HEAD
      ../modules/headless/clamav.nix
      ../modules/desktop/plasma-desktop.nix
      ../modules/desktop/webbrowser.nix
=======
      ../modules/desktop/plasma-desktop.nix      
>>>>>>> 6b4ad8e6d91895833415ce38a1cf2a1d12be25ee
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
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = vars.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = "nl_NL.UTF-8";
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tanya = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      chromium
    ];
  };

  users.users.sander = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      chromium
      remmina
      git
      partition-manager
      kate
      trilium-desktop
      vlc
      fdupes
    ];
  };

  services.displayManager.sddm.settings = {
    Autologin = {
        User = "sander";
    };
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    chromium
    remmina
    thunderbird
    kate
    partition-manager
    git
    gh
    inetutils

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
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  programs.chromium = {
    enable = true;
    homepageLocation = "https://933k.nl:8123";
    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL = "https://www.google.nl";
    extensions = [
       "nngceckbapebfimnlniiiahkandclblb" # bitwarden
    ];
    extraOpts = {
      BrowserSignin = 0;
      SyncDisabled = true;
      PasswordManagerEnabled = false;
      SpellcheckEnabled = true;
      SpellcheckLanguage = [
        "nl-NL"
      ];
    };
  };

#  nixpkgs.config.allowUnfree = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

