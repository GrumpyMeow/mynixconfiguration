{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
  domain = "mail.933k.nl";
in
{  
  networking.firewall.allowedTCPPorts = [
    80 # HTTP
    443 # HTTPS
    8081 # Management web
    465 # SMTP-submission
    993 # IMAP-TLS
    143 # IMAP
    25 # SMTP
    4190 # Sieve
    587 # SMTP-submission
  ];

  services.stalwart-mail = {
    enable = true;
    package = pkgs.stalwart-mail;
    settings = {
      global.tracing.level = "trace";
      # authentication.fallback-admin = {
      #   user = "admin";
      #   secret = "$6$R469iElYzZ7v7TlV$PtJpqLO0Szw.B/r8V.puCC26i5.nfQLJQotTWrNoBsTrFo6/J1pC43OIMKc.2Oli/Of0pjPcgbBNmhfFImuuu0";
      # };
      lookup.default.hostname = "mail.${vars.publicDomain}";
      server = {
        max-connections = 8192;
        hostname = "mail.${vars.publicDomain}";
        tls.enable = true;
        listener = {
          "smtp" = {
            bind = [ "[::]:25" ];
            protocol = "smtp";
          };
          "smtp-submission" = {
            bind = "[::]:587";
            protocol = "smtp";
          };
          "smtp-submissions" = {
            bind = [ "[::]:465" ];
            protocol = "smtp";
            tls.implicit = true;
          };
          "imap" = {
            bind = [ "[::]:143" ];
            protocol = "imap";
          };
          "imaptls" = {
            bind = [ "[::]:993" ];
            protocol = "imap";
            tls.implicit = true;
          };
          "http" = {
            bind = "[::]:80";
            protocol = "http";
          };

          "https" = {
            bind = "[::]:443";
            protocol = "http";
            tls.implicit = true;
          };

          "sieve" = {
            bind = "[::]:4190";
            protocol = "managesieve";
          };

          "management" = {
            bind = "[::]:8081";
            protocol = "http";
          };
        };
      };
    };
  };

}

#https://github.com/JulienMalka/snowfield/blob/77a2d02d9ee40c91d51a32b1c0c5d38f5efc4a27/machines/akhaten/stalwart.nix