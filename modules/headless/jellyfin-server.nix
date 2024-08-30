{ config, lib, pkgs, ... }:
with lib;
let
in
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
