{ config, lib, pkgs, ... }:

with lib;

let
  unstableTarball =
    fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      sha256 = "sha256:1vc8bzz04ni7l15a9yd1x7jn0bw2b6rszg1krp6bcxyj3910pwb7";
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
