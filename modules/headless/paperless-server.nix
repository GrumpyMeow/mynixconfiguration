{ config, lib, pkgs, ... }:

with lib;

let

in

{
  networking.firewall = {
    checkReversePath = "loose";
    interfaces.eth0 = {
      allowedTCPPorts = [ 28981 ];
    };
  };

  environment.etc."paperless-admin-pass".text = "admin";

  services.paperless = {
    enable = true;
    address = "0.0.0.0";
    passwordFile = "/etc/paperless-admin-pass";
    port = 28981;
    settings = {
      PAPERLESS_AUTO_LOGIN_USERNAME = "admin";
      PAPERLESS_OCR_LANGUAGE = "nld+eng";
    };
  };

}
