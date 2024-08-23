{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
  unstableTarball =
    fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      sha256 = "sha256:1vc8bzz04ni7l15a9yd1x7jn0bw2b6rszg1krp6bcxyj3910pwb7";
    };

in
{  

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };


  services.zabbixAgent = {
    enable = true;
    package = pkgs.unstable.zabbix64.agent2;
    server = vars.zabbixServerIP;
    openFirewall = true;
    settings = {
      Hostname = "${vars.hostName}.${vars.domain}";
      ServerActive = vars.zabbixServerIP;
      AllowKey = "system.run[*]";
      #AllowRoot = 1;
    };
  };
}
