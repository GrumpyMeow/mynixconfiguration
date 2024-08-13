{ config, lib, pkgs, ... }:

with lib;

let
  unstableTarball =
    fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      sha256 = "sha256:0gnmmn1wc09z1q4bb8jkqi2f8vxl26kaa3xrs664q9i651am2mkl";
    };

  vars = import ../../vars.nix;
in
{ 
  # Todo: Make predicate specific to mqtt-explorer. Didnt get it to work.
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pkgs.unstable.mqtt-explorer
  ];  
   
}
