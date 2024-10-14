{ config, pkgs, modulesPath, lib, system, ... }:

let
    vars = import ../vars.nix;
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
#    ../modules/headless/zabbix-agent.nix 
    ../modules/headless/generic.nix 
    ./nixdesktop/qbittorrent.nix
  ];

  
  
  config = {
    
    #zabbixAgent.hostName = "qbittorrent.${vars.domain}";

    nixpkgs = {
      config = {
        allowUnfree = true;
        packageOverrides = pkgs: {
          unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
        };
      };
    };

    #Provide a default hostname
    networking.hostName = lib.mkDefault "qbittorrent";
    networking.firewall.enable = false;

    # Enable QEMU Guest for Proxmox
    services.qemuGuest.enable = lib.mkDefault true;

    # proxmox = {
    
    #   qemuConf = {
    #     cores = 4;
    #     memory = 4096;
    #     name = "privado";
    #     net0 = "virtio=BC:24:22:8B:6C:00,bridge=vmbr0,firewall=1";
    #     additionalSpace = "2048M";
    #     virtio0 = "local-btrfs:vm-9999-disk-0";
    #   };
    # };

    services.cloud-init.network.enable = false;

        # Use the boot drive for grub
    boot.loader.grub.enable = lib.mkDefault true;
    boot.loader.grub.devices = [ "nodev" ];

    boot.growPartition = lib.mkDefault true;

    # Allow remote updates with flakes and non-root users
    nix.settings.trusted-users = [ "root" "@wheel" ];
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Allow the user to login as root without password.
    users.users.root.initialHashedPassword = lib.mkOverride 150 "";

    # Some more help text.
    services.getty.helpLine = ''

      Log in as "root" with an empty password.
    '';

    # Default filesystem
    fileSystems."/" = lib.mkDefault {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
    };

    # Some sane packages we need on every system
    environment.systemPackages = with pkgs; [
      vim  # for emergencies
      git # for pulling nix flakes
      qbittorrent-nox
      wireguard-go
      boringtun
      wireguard-tools 
    ];

    fileSystems."/Downloads" = {
      device = "//hub.${vars.domain}/zpool-storage/downloads/qBittorrent"; 
      fsType = "cifs";
      #
      options = [      
        "uid=990"
        "gid=988"
        #"guest"
        "nofail"
        "noauto"
        "rw"
        "rsize=16777216"
        "cache=loose"
        "x-systemd.after=network.target"
      ];
    };

    networking.enableIPv6 = false;

    networking.firewall = {
      allowedUDPPorts = [ 51820 ];
    };

    networking.firewall.trustedInterfaces = [ "wg0" ];
    networking.wireguard.enable = true;

    networking.nat = {
      enable = true;
      internalInterfaces = [ "wg0" ];
      externalInterface = "ens18";
    };

    
    networking.wg-quick.interfaces = {
      # ams-031
      # wg0 = {
      #   address = [ "100.64.69.5/32" ];
      #   dns = [ "198.18.0.1" "198.18.0.2" ];
      #   privateKey = "IDZtF09wpeqpQSZ1yMhJ2H2mPlftVMWie0ajzIr6PlU=";        
      #   peers = [
      #     {
      #       publicKey = "KgTUh3KLijVluDvNpzDCJJfrJ7EyLzYLmdHCksG4sRg=";
      #       allowedIPs = [ "0.0.0.0/0" ];
      #       endpoint = "91.148.241.53:51820";
      #       persistentKeepalive = 25;
      #     }
      #   ];
      # };
      # ams-030
      # wg0 = {
      #   address = [ "100.64.3.22/32" ];
      #   dns = [ "198.18.0.1" "198.18.0.2" ];
      #   privateKey = "4MG2RJvdQbwSOdtyLgwWDWxMIAHQY5vEMRAySdv2tm4=";        
      #   peers = [
      #     {
      #       publicKey = "KgTUh3KLijVluDvNpzDCJJfrJ7EyLzYLmdHCksG4sRg=";
      #       allowedIPs = [ "0.0.0.0/0" ];
      #       endpoint = "91.148.241.45:51820";
      #       persistentKeepalive = 25;
      #     }
      #   ];
      # };
      # ams-027
      wg0 = {
        address = [ "100.64.3.112/32" ];
        dns = [ "198.18.0.1" "198.18.0.2" ];
        privateKey = "4DK1FHub3vDfIQ50IuWB+/h1230MWBzS0Itj5Q+nDEs=";        
        peers = [
          {
            publicKey = "KgTUh3KLijVluDvNpzDCJJfrJ7EyLzYLmdHCksG4sRg=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "91.148.241.21:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };

    services.qbittorrent = {
       enable = true;
       openFirewall = true;
       port = 58080;
       user = "media";
       group = "media";
    };
    users.users.media = {
       group = "media";
       isSystemUser = true;
       uid = 1001;
    };
    users.groups.media = { gid = 1001; };


    system.stateVersion = lib.mkDefault "24.05";
  };
}
# nixos-generate -c /root/mynixconfiguration/machines/qbittorrent.nix -f proxmox
# nixos-rebuild -c /root/mynixconfiguration/machines/qbittorrent.nix --target-host 192.168.1.163 switch
# nixos-rebuild -I nixos-config=/root/mynixconfiguration/machines/qbittorrent.nix --target-host 192.168.1.163 --use-remote-sudo
# nixos-rebuild --flake .#flakeTarget --target-host user@remote-host --use-remote-sudo


# systemctl stop qbittorrent.service
# nano /var/lib/qBittorrent/config/qBittorrent.config
#[Preferences]
#WebUI\AuthSubnetWhitelist=192.168.1.0/24
#WebUI\AuthSubnetWhitelistEnabled=true
#WebUI\Port=58080
# systemctl start qbittorrent.service
# Firewall:
# * Allow inbound TCP 22 for sftp/ssh
# * Allow inbound TCP 58080 for WebUI
# * Allow outbound UDP 51820 for Wireguard
# * Drop inbound+outbound default

# If no connection, restart qbittorrent
# systemctl restart qbittorrent.service
# or:
