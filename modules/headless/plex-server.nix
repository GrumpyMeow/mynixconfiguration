{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{
  networking.firewall.allowedTCPPorts = [ 32400 ];
  
  environment.etc = {
      "Preferences.xml" = {
        text = ''<?xml version="1.0" encoding="utf-8"?>
<Preferences OldestPreviousVersion="1.40.2.8395-c67dce28e" MachineIdentifier="${vars.plex.machineIdentifier}" ProcessedMachineIdentifier="${vars.plex.processedMachineIdentifier}" AnonymousMachineIdentifier="${vars.plex.anonymousMachineIdentifier}" MetricsEpoch="1" GlobalMusicVideoPathMigrated="1" AcceptedEULA="1" PublishServerOnPlexOnlineKey="0" PlexOnlineToken="${vars.plex.online.token}" PlexOnlineUsername="${vars.plex.online.username}" PlexOnlineMail="${vars.plex.online.mail}" PlexOnlineHome="${vars.plex.online.home}" DlnaEnabled="0" DvrIncrementalEpgLoader="0" CertificateUUID="${vars.plex.certificateUUID}" PubSubServerPing="82" CertificateVersion="3" LastAutomaticMappedPort="0" logDebug="0" ScannerLowPriority="1" ScheduledLibraryUpdateInterval="86400" EnableIPv6="0" RelayEnabled="0" WebHooksEnabled="0" allowedNetworks="${vars.plex.allowedNetworks}" customConnections="${vars.plex.customConnections}" CinemaTrailersFromLibrary="0" CinemaTrailersIncludeEnglish="0" LanguageInCloud="1"/>
      '';
      };
  };
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "plexmediaserver"
  ];
  services.plex = {
    enable = true;
    openFirewall = true;
  };
  #environment.systemPackages = [ pkgs.cifs-utils ];

  fileSystems."/mnt/Movies" = {
    device = "//hub.${vars.domain}/media/Movies"; 
    fsType = "cifs";
  };

  fileSystems."/mnt/Series" = {
    device = "//hub.${vars.domain}/media/Series"; 
    fsType = "cifs";
  };

  fileSystems."/mnt/Music" = {
    device = "//hub.${vars.domain}/media/Music"; 
    fsType = "cifs";
  };


  system.activationScripts = { 
    plex.text =
      ''
      mkdir -p /var/lib/plex/Plex\ Media\ Server/
      cp --force /etc/Preferences.xml /var/lib/plex/Plex\ Media\ Server/Preferences.xml
      '';
  };

  #https://github.com/NixOS/nixpkgs/issues/173338
  systemd.services.plex.serviceConfig = let
    pidFile = "${config.services.plex.dataDir}/Plex Media Server/plexmediaserver.pid";
  in {
    KillSignal = lib.mkForce "SIGKILL";
    Restart = lib.mkForce "no";
    TimeoutStopSec = 10;
    ExecStop = pkgs.writeShellScript "plex-stop" ''
      ${pkgs.procps}/bin/pkill --signal 15 --pidfile "${pidFile}"

      # Wait until plex service has been shutdown
      # by checking if the PID file is gone
      while [ -e "${pidFile}" ]; do
        sleep 0.1
      done

      ${pkgs.coreutils}/bin/echo "Plex shutdown successful"
    '';
    PIDFile = lib.mkForce "";
  };

}
