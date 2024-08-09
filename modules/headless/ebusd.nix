{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;

  ebusdconfig = pkgs.fetchFromGitHub {
    owner = "GrumpyMeow"; # "john30";
    repo = "ebusd-configuration";
    rev = "8c722a166176d9ccd9e61b4c488bf4d6fdea718a"; # "0d875e33573ff6545bba3577365cc0d8a16e798b";
    sha256 = "sha256-veU37h+Fo6quB7a11C/kvN+DpWkOhHz3Z/bDn+aJQ38=";
  };

in
{  
  imports = [
     ./ebusd-service.nix
  ];
  
  services.ebusd-t = {
    enable = true;
    port = 8888;
    device = "/dev/serial/by-id/usb-Silicon_Labs_CP2104_USB_to_UART_Bridge_Controller_018437BD-if00-port0";
    scanconfig = "full";
    configpath = "${ebusdconfig}/ebusd-2.1.x/en/";
    mqtt = {
      enable = true;
      home-assistant = true;
      host = "${vars.mqttServerHostName}.${vars.domain}";
      port = vars.mqttPort;
      user = "";
      password = "";
    };
    logs = {
      main = "error";
      network = "error";
      bus = "error";
      update = "error";
      other = "error";
      all = "error";
    };
    extraArguments = [
      "--latency=0" 
    ];
  };

  #environment.systemPackages = with pkgs; [ 
  #  ebusd
  #];


}
