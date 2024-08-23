{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
   users.users.nginx.extraGroups = [ "acme" ];

   security.acme = {
     acceptTerms = true;
     defaults = {
      email = vars.acme.mailaddress;
      dnsProvider = "transip";
      dnsResolver = "ns1.transip.nl:53";
      dnsPropagationCheck = true;
      environmentFile = pkgs.writeText "transipEnvFile" ''
        TRANSIP_ACCOUNT_NAME = "${vars.acme.transipAccountName}"
        TRANSIP_PRIVATE_KEY_PATH = ${pkgs.writeText "transip_private_key" vars.acme.privateKey}
      '';
      enableDebugLogs = true;
     };
     certs."${vars.publicDomain}" = {
       domain = "*.${vars.publicDomain}";
       #domain = vars.publicDomain;
       #extraDomainNames = [ "*.${vars.publicDomain}" ];
     };
   };

  services.nginx = {
    enable = true;
    # recommendedTlsSettings = true;
    # recommendedProxySettings = true;
    # recommendedGzipSettings = true;
    # recommendedOptimisation = true;
    # clientMaxBodySize = "300m";
    # logError = "stderr debug";

    # # Only allow PFS-enabled ciphers with AES256
    # sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
  };

  networking.firewall.allowedTCPPorts = [80 443];

  # catch-all
  services.nginx.virtualHosts."_" = {
    useACMEHost = vars.publicDomain;
    forceSSL = true;
    default = true;
    locations."~ .*".return = "403";
  };

  # environment.persistence = {
  #   "/persist".directories = ["/var/lib/acme"];
  # };


}
