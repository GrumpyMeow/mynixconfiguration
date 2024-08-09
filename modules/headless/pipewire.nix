{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
  services.pipewire = {
    enable = true;
  };
}
