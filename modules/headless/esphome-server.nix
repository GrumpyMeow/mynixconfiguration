{ config, lib, pkgs, ... }:

with lib;

let
   unstableTarball =
    fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      sha256 = "sha256:0gnmmn1wc09z1q4bb8jkqi2f8vxl26kaa3xrs664q9i651am2mkl";
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
