{ config, lib, pkgs, ... }:

with lib;

let
    vars = import ../../vars.nix;
in

{
  hardware.rtl-sdr.enable = true;

  environment.systemPackages = [
    pkgs.rtl-sdr
    pkgs.soapyrtlsdr
    pkgs.soapysdr
    pkgs.soapyremote
  ];
}
