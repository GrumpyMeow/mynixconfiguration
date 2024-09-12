{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
  environment.systemPackages = [
    pkgs.crowdsec
  ];
}

#not working
