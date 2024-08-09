{ config, lib, pkgs, ... }:

with lib;

let
  unstableTarball =
    fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      sha256 = "sha256:19nv90nr810mmckhg7qkzhjml9zgm5wk4idhrvyb63y4i74ih2i0";
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
