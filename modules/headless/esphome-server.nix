{ config, lib, pkgs, ... }:

with lib;

let
   unstableTarball =
    fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      sha256 = "sha256:19nv90nr810mmckhg7qkzhjml9zgm5wk4idhrvyb63y4i74ih2i0";
    };
in
{
  networking.firewall = {
    checkReversePath = "loose";
    interfaces.eth0 = {
      allowedTCPPorts = [ 6052 ];
    };
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  
  services.esphome = {
    enable = true;
    openFirewall = true;
    address = "0.0.0.0";
    package = pkgs.unstable.esphome;
  };

}
