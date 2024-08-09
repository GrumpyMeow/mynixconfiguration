{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
   security.acme.acceptTerms = true;
   security.acme.defaults.email = vars.acmeMailaddress;

#   networking.firewall = {
#     checkReversePath = "loose";
#     interfaces.eth0 = {
#       allowedTCPPorts = [ 80 ];
#     };
#   };

   services.nginx = {
     enable = true;
   };

}
