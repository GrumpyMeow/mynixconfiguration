{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
   
  environment.sessionVariables = rec {
    PULSE_SERVER = "tcp:${vars.subnetPrefixIP}.2";
  };
  services.pipewire = {
    pulse.enable = true;
  };
}
