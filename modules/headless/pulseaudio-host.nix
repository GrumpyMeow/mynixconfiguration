{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
   
  environment.sessionVariables = rec {
    PULSE_SERVER = "tcp:hub.lan.5";
  };
  services.pipewire = {
    pulse.enable = true;
  };
}
