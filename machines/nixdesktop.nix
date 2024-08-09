{ config, pkgs, lib, ... }:

{
  imports = [ 
    <nixpkgs/nixos/modules/virtualisation/lxc-container.nix> 
    ./nixdesktop/qbittorrent.nix
    ./nixdesktop/printer.nix
    ./nixdesktop/zabbixagent.nix
    ./nixdesktop/pipewire.nix
    ./nixdesktop/pulseaudio-host.nix
    ./nixdesktop/plasma-desktop.nix
    ./nixdesktop/webbrowser.nix
    ./nixdesktop/nrf-wireshark.nix
  ];

  console.enable = true;

  systemd.services."getty@" = {
    unitConfig.ConditionPathExists = ["" "/dev/%I"];
  };

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  nix.settings = {
    auto-optimise-store = true;
    sandbox = false;
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config = { 
    allowUnfree = true; 
  };

  hardware.bluetooth.enable = true;

#  services.qbittorrent = {
#    enable = true;
#    openFirewall = true;
#    port = 58080;
#    user = "media";
#    group = "media";
#  };
#  users.users.media = {
#    group = "media";
#    isSystemUser = true;
#    uid = 1001;
#  };
#  users.groups.media = { gid = 1001; };
  
  services.power-profiles-daemon.enable = false;
  powerManagement.enable = false;
  services.upower.enable = false;

  services.flatpak.enable = true;
  services.udisks2.enable = lib.mkForce false;

  services.bind.ipv4Only = true;

  networking = {
    dhcpcd = {
      IPv6rs = false;
    };
    hostName = "nixos";
    enableIPv6 = false;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowPing = true;
      logRefusedConnections = true;
    };
  };

  time.timeZone = "Europe/Amsterdam";

  i18n = {
    defaultLocale = "nl_NL.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "nl_NL.UTF-8";
      LC_IDENTIFICATION = "nl_NL.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      LC_NAME = "nl_NL.UTF-8";
      LC_NUMERIC = "nl_NL.UTF-8";
      LC_PAPER = "nl_NL.UTF-8";
      LC_TELEPHONE = "nl_NL.UTF-8";
      LC_TIME = "nl_NL.UTF-8";
      LC_COLLATE = "nl_NL.UTF-8";
      LC_MESSAGES = "nl_NL.UTF-8";
      LC_CTYPE = "nl_NL.UTF-8";
      LC_ALL = "nl_NL.UTF-8";
    };
  };

  services.clamav = {
    daemon.enable = true;
    updater = {
      enable = true;
      interval = "daily";
    };
  };

  services.accounts-daemon.enable = lib.mkForce false;
  systemd.services.powerdevil = {
    wantedBy = lib.mkForce [];
    enable = false;
  };
  systemd.services.rfkill = {
    wantedBy = lib.mkForce [];
    enable = false;
  };
  #systemd.services.modem-manager.enable = false;
  #systemd.services."dbus-org.freedesktop.ModemManager1".enable = false;
  
  #programs.bash.completion.enable = true;

  users.defaultUserShell = pkgs.bash;

  security.sudo.wheelNeedsPassword = false;
  users.users.system = {
    isNormalUser = true;
    home = "/home/system";
    description = "System user";
    extraGroups = [ 
      "wheel" 
      "audio"
      "networkmanager"
      "scanner"
      "lp"
      "render"
    ];
    shell = pkgs.bash;
  };

  environment.systemPackages = with pkgs; [
    pkgs.wget
    pkgs.dig # NSLookup etc.
    pkgs.nmap
    pkgs.traceroute
    pkgs.git
    pkgs.inetutils

    pkgs.discord
    pkgs.git
    pkgs.gh
  ];  

  system.stateVersion = "24.05";
}

# 20240620 17:25 Pulseaudio not system-wide. Pulseaudio not connecting to host.
# 20240620 17:50 Added nmap package
# 20240620 18:30 Added NixOS Home Manager as module
# 20240626 09:00 Modemmanager uitgecommentarieerd om 25sec wachten (zie log) te voorkomen
# 20240626 09:01 Pipewire instellen, want foutmeldingen in logs

# todo: Hacompanion instellen flake
# todo: opensnitch opstarten en rules provisioning
# todo: audiotube checken
# todo: wireguard provisionen
# todo: zabbix agent
# todo: goldwarden i.p.v. bitwarden desktop?
