{ config, lib, pkgs, ... }:
with lib;
let
  vars = import ../../vars.nix;
in
{
  services.jellyfin = {
    package = pkgs.unstable.jellyfin;
    enable = true;
    openFirewall = true;
  };

  users.users.jellyfin = {
    extraGroups = [ "render" "video" ];
  };

  environment.systemPackages = [
    pkgs.amdgpu_top
    pkgs.radeontop
    pkgs.libva-utils
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;

    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  services.nginx.virtualHosts."jellyfin" = {
    useACMEHost = vars.publicDomain;
    http2 = true;
    serverName = "jellyfin.${vars.publicDomain}";
    forceSSL = true;
    extraConfig = ''
      send_timeout 100m;
      proxy_read_timeout 300;
      proxy_connect_timeout 300;
      proxy_send_timeout 300; 
      #proxy_redirect off;
      #proxy_buffering off;
    '';        
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096";
      proxyWebsockets = true;
    };   
  };

  # Resolves "Reader cannot keep up" while transcoding live TV
  fileSystems."/var/cache/jellyfin/transcodes" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=0" "mode=777" "noswap"  ];
  };
}
