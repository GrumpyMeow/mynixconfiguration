{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{       
  environment.systemPackages = with pkgs; [
    pkgs.discord
  ];  

}
