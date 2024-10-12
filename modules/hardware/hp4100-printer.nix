{ config, lib, pkgs, ... }:

with lib;

let
  unstableTarball =
    fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    };

  vars = import ../../vars.nix;
in
{ 
   nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
   }; 

   networking.firewall.allowedUDPPorts = [
     5353 # mDNS
     427 # Service Location Protocol (SLP)
     631
   ];

   networking.firewall.allowedTCPPorts = [
     631
   ];

   environment.systemPackages = [
    pkgs.hplip
    pkgs.cups-printers
   ];

   services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
      ipv6 = true;
      ipv4 = true;
      #domainName = "local";
    };  

    printing = {
      enable = true;
      startWhenNeeded = false;
      drivers = [ pkgs.hplipWithPlugin ]; 
      logLevel = "debug";
      cups-pdf.enable = true;
    };

  };

  hardware = {
    printers = {
     ensurePrinters = [
        {
          name = "hp4100e";
          location = "Home";
          deviceUri = "ipp://HP15E25C.${vars.domain}";
          model = "HP/hp-deskjet_4100_series.ppd.gz";
          description = "HP Deskjet 4100e";
          ppdOptions = {
            PageSize = "A4";
            ColorModel = "RGB";
            MediaType = "Plain";
            OutputMode = "Normal";
            InputSlot = "Auto";
          };
        }
      ];
      ensureDefaultPrinter = "hp4100e";
    };
  

    sane = {
      enable = true;
      extraBackends = [ pkgs.hplipWithPlugin pkgs.sane-airscan ];
    };
  };

}
# NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup'