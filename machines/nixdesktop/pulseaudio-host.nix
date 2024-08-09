{ config, lib, pkgs, ... }:

with lib;

let

in

{
  environment.sessionVariables = rec {
    PULSE_SERVER = "tcp:192.168.178.2";
  };
  services.pipewire = {
    pulse.enable = true;
  };

}
