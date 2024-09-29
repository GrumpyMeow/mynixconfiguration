{ config, pkgs, ... }:
let
    vars = import ../vars.nix;
in
{ 
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/root/mynixconfiguration/machines/nixserver.nix"
    "/root/.nix-defexpr/channels"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
      };
    };
  };


  imports = [ 
    <nixpkgs/nixos/modules/virtualisation/proxmox-lxc.nix> 
    ../modules/headless/zabbix-agent.nix 
    ../modules/headless/mqtt-server.nix
    ../modules/headless/frigate-server.nix
    ../modules/headless/esphome-server.nix
    ../modules/headless/plex-server.nix
    ../modules/headless/code-server.nix
    ../modules/headless/web-server.nix
    ../modules/headless/vaultwarden-server.nix
    ../modules/headless/trilium-server.nix
    ../modules/headless/tailscale.nix
    ../modules/headless/ebusd.nix
    ../modules/headless/zigbee2mqtt.nix
    ../modules/headless/jellyfin-server.nix
    #../modules/headless/rtlsdr.nix    
    #./modules/headless/mail-server.nix
    #./modules/headless/mqtt-explorer.nix
    # ./modules/paperless-server.nix    
    ../modules/headless/generic.nix
  ];

  zabbixAgent.hostName = "${vars.hostName}.${vars.domain}";  

  boot.isContainer = true;
  #boot.tmp.useTmpfs = true; # Disabled Tmpfs to allow for nixos-generate to build images to disk and not memory (oom)

  console.enable = true;
  systemd.services."getty@" = {
    unitConfig.ConditionPathExists = ["" "/dev/%I"];
  };

  boot.kernel.sysctl."net.ipv6.conf.eth0.disable_ipv6" = true;

  services.resolved = {
    enable = false;
  };

  networking = {
    hostName = "${vars.hostName}";
    domain = vars.domain;
    search = [ "lan" ];
    defaultGateway = {
      address = vars.gateway;
      interface = "eth0";
    };
    
    resolvconf = {
      enable = true;
      extraConfig = ''
        search_domains_append="lan"
        prepend_nameservers="192.168.1.1"
        name_servers_append="192.168.1.1"
        '';
    };
    
    nameservers = [ vars.upstreamDNS ];
    extraHosts =
      ''
        ${vars.mqttServerIP} ${vars.mqttServerHostName}.${vars.domain}
        ${vars.subnetPrefixIP}.5 hub.${vars.domain}
        ${vars.zabbixServerIP} ${vars.zabbixServerHostName}.${vars.domain}
      '';

    firewall = {
      enable = true;
      allowPing = true;
      logRefusedPackets = true;
      logRefusedConnections = true;
    };

    nat.enable = false;
    enableIPv6 = false;

    useDHCP = false;
    hosts = {
      "127.0.0.1" = [ "localhost" "${vars.hostName}" "${vars.hostName}.${vars.domain}" ];
    };

    interfaces = {
      "eth0" = {
        ipv4.addresses = [
          { address = vars.ip; prefixLength = 24; }
        ];
      };
    };
    networkmanager.enable = false;
  };

  programs.nix-ld.enable = true;

  # Reduces writes onto disk
  services.journald = { 
    storage = "volatile";
    extraConfig = "SystemMaxUse=100M";
  };

  environment.systemPackages = with pkgs; [
    pkgs.fatrace pkgs.iotop pkgs.inotify-tools pkgs.atop
    pkgs.iperf
    pkgs.nixos-generators
  ];

  system.stateVersion = "24.05";
}
