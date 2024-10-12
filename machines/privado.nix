{ config, pkgs, modulesPath, lib, system, ... }:

let
    vars = import ../vars.nix;
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../modules/headless/zabbix-agent.nix 
    ../modules/desktop/plasma-desktop.nix
    ../modules/desktop/webbrowser.nix
    ../modules/headless/zabbix-agent.nix
    ../modules/headless/code-server.nix
  ];
  
  config = {
    
    #zabbixAgent.hostName = "privado.${vars.domain}";

    nixpkgs = {
      config = {
        allowUnfree = true;
        packageOverrides = pkgs: {
          unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
        };
      };
    };

    #Provide a default hostname
    networking.hostName = lib.mkDefault "privado";

    # Enable QEMU Guest for Proxmox
    services.qemuGuest.enable = lib.mkDefault true;

    proxmox = {

      # cloudInit = {
      #   enable = false;
      #   defaultStorage = "local-btrfs";
      # };
    
      qemuConf = {
        cores = 4;
        memory = 4096;
        name = "privado";
        net0 = "virtio=BC:24:22:8B:6C:00,bridge=vmbr0,firewall=1";
        additionalSpace = "2048M";
        virtio0 = "local-btrfs:vm-9999-disk-0";
      };
    };

    services.cloud-init.network.enable = false;

    # Use the boot drive for grub
    boot.loader.grub.enable = lib.mkDefault true;
    boot.loader.grub.devices = [ "nodev" ];

    boot.growPartition = lib.mkDefault true;

    # Allow remote updates with flakes and non-root users
    nix.settings.trusted-users = [ "root" "@wheel" ];
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Some sane packages we need on every system
    environment.systemPackages = with pkgs; [
      vim  # for emergencies
      git # for pulling nix flakes
      qbittorrent
    ];

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


    system.stateVersion = lib.mkDefault "24.05";
  };
}
# nixos-generate -c /root/mynixconfiguration/machines/privado.nix -f proxmox