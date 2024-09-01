{ config, lib, pkgs, ... }:
with lib;
let
in
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users.users.jellyfin = {
    extraGroups = [ "render" ];
  };

  environment.systemPackages = [
    pkgs.amdgpu_top
    pkgs.radeontop
  ];
}
