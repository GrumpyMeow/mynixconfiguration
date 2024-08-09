{ config, lib, pkgs, ... }:

with lib;

let

in

{
  services.pipewire = {
    enable = true;
  };

}
