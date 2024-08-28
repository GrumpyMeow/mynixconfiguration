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

  imports = [ 
    <nixpkgs/nixos/modules/virtualisation/proxmox-lxc.nix> 
    ../modules/headless/dhcp-server.nix
    ../modules/headless/dns-server.nix
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
    ../modules/headless/ntp-server.nix
    #../modules/headless/rtlsdr.nix    
    #./modules/headless/ntopng-server.nix
    #./modules/headless/mail-server.nix
    #./modules/headless/mqtt-explorer.nix
    # ./modules/paperless-server.nix    
    # ./modules/reverse-proxy.nix
    # ./modules/prometheus-server.nix
    # ./modules/mdns-server.nix
    
  ];

  boot.isContainer = true;
  boot.tmp.useTmpfs = true;

  console.enable = true;
  systemd.services."getty@" = {
    unitConfig.ConditionPathExists = ["" "/dev/%I"];
  };

  time.timeZone = vars.timezone;

  #boot.kernel.sysctl."net.ipv6.conf.eth0.disable_ipv6" = true;

  services.resolved = {
    enable = false;
  };


  networking = {
    hostName = vars.hostName;
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
        prepend_nameservers="192.168.178.1"
        name_servers_append="192.168.1.1"
        '';
    };
    
    nameservers = [ vars.upstreamDNS ];
    extraHosts =
      ''
        ${vars.mqttServerIP} ${vars.mqttServerHostName}.${vars.domain}
        ${vars.subnetPrefixIP}.2 hub.${vars.domain}
        ${vars.zabbixServerIP} ${vars.zabbixServerHostName}.${vars.domain}
      '';

    firewall = {
      enable = true;
      allowPing = true;
      logRefusedPackets = true;
      logRefusedConnections = true;
    };

    nat.enable = false;
    #enableIPv6 = false;

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

  services.openssh.settings = {
    PermitRootLogin = "yes";
    PermitEmptyPasswords = "yes";
    PasswordAuthentication = true;
  };

  security.pam.services.sshd.allowNullPassword = true;
  programs.nix-ld.enable = true;

  # Reduces writes onto disk
  services.journald = { 
    storage = "volatile";
    extraConfig = "SystemMaxUse=100M";
  };

  nix.settings.auto-optimise-store = true;
  
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 1d";
  };

  environment.systemPackages = with pkgs; [
    pkgs.git
    pkgs.nano 
    pkgs.wget
    pkgs.man pkgs.man-pages pkgs.man-pages-posix
    pkgs.fatrace pkgs.iotop pkgs.inotify-tools
    pkgs.iperf
    pkgs.nixos-generators
    pkgs.gh
  ];

  documentation.dev.enable = true;
  documentation.man.enable = true;

  system.stateVersion = "24.05";
}
