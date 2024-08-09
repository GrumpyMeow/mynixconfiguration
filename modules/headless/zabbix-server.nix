{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
   
   services.zabbixServer = {
     enable = true;
     openFirewall = true;
     listen = {
       port = 10051;
       ip = "0.0.0.0";
     };
     database = {
       createLocally = true;
     }
   };

}
