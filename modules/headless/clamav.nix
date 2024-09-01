{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
  services.clamav = {
    daemon.enable = true; 
    updater.enable = true;
  };

}
