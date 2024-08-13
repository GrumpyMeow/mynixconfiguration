{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
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
       domain = vars.publicDomain;
       extraDomainNames = [ "*.${vars.publicDomain}" ];
     };
   };


   services.nginx = {
     enable = true;
   };

}
