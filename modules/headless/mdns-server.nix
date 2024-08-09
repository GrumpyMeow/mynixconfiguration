{ config, lib, pkgs, ... }:

with lib;

let

in

{
  #networking.firewall = {
  #  checkReversePath = "loose";
  #  interfaces.eth0 = {
  #    allowedUDPPorts = [ 5353 ];
  #  };
  #};

  services.avahi = {
    enable = true;
    openFirewall = true;
    hostName = "nixserver";
    allowInterfaces = [ "eth0" ];
    domainName = "lan";
    ipv4 = true;
    ipv6 = false;
    nssmdns4 = true;
    nssmdns6 = false;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      userServices = true;
    };
  };

}
# https://pavluk.org/blog/2022/01/26/nixos_router.html
