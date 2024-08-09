{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
  hawwc = pkgs.fetchFromGitHub {
    owner = "fwartner";
    repo = "home-assistant-wakewords-collection";
    rev = "bf902f133a6eed326bbbc0a704e7acfe6c4b76f9";
    sha256 = "ok169t00miG1DHOTnJhSeUmmy27NGDZfKFlMZD8p2ps=";
  };

in
{  
  hardware.pulseaudio = {
    enable = true;
    systemWide = true;
    extraConfig = "load-module module-native-protocol-tcp";
    extraClientConf = "default-server = tcp:${vars.subnetPrefixIP}.2:4713";
  };

  networking = {
    hostName = "wyomingsatellite";
    enableIPv6 = false;
    networkmanager.enable = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 10400 10700 ];
      allowPing = true;
      logRefusedConnections = true;
    };
  };

  services.wyoming.satellite = {
    enable = true;
    name = "308 Wyoming Satellite";
    user = "root";
    area = "Werkplek Sander";
    uri = "tcp://0.0.0.0:10700";
    sounds.awake = builtins.fetchurl "https://github.com/rhasspy/wyoming-satellite/raw/master/sounds/awake.wav";
    sounds.done = builtins.fetchurl "https://github.com/rhasspy/wyoming-satellite/raw/master/sounds/done.wav";
    extraArgs = [ 
      "--wake-word-name=computer" 
      "--wake-uri=tcp://127.0.0.1:10400" 
      "--zeroconf-name=wyomingsatellite"
      "--debug"
    ];
    microphone = {
      autoGain = 5;
      noiseSuppression = 2;
    };
    vad.enable = false;
  };
  
  services.wyoming.openwakeword = {
    enable = true;
    customModelsDirectories = [
      "${hawwc}/en/computer/"
    ];
    preloadModels = [
      "computer"
    ];
    uri = "tcp://0.0.0:10400";
    extraArgs = [
      "--debug"
    ];
    threshold = 0.5;
    triggerLevel = 1;
  };

  environment.systemPackages = with pkgs; [
    pkgs.alsa-utils
  ];  

}
