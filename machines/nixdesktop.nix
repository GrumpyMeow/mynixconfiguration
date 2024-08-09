{ config, pkgs, lib, ... }:
let
  vars = import ../vars.nix;

in
{
  imports = [ 
    <nixpkgs/nixos/modules/virtualisation/proxmox-lxc.nix> 
    ../modules/hardware/hp4100-printer.nix
    ../modules/headless/zabbix-agent.nix
    ../modules/headless/code-server.nix
    ../modules/headless/pulseaudio-host.nix
    ../modules/desktop/plasma-desktop.nix
    ../modules/desktop/webbrowser.nix
    ../modules/desktop/discord.nix
    ../modules/desktop/printer-scanner.nix
    ../modules/desktop/pipewire.nix
#   ./nixdesktop/qbittorrent.nix
#   ./nixdesktop/nrf-wireshark.nix
  ];

  boot.isContainer = true;
  boot.tmp.useTmpfs = true;

  console.enable = true;
  systemd.services."getty@" = {
    unitConfig.ConditionPathExists = ["" "/dev/%I"];
  };

  time.timeZone = vars.timezone;

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
    pkgs.git
    pkgs.gh
  ];  

  system.stateVersion = "24.05";
}
