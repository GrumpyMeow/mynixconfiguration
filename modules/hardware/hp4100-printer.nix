{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
   services = {

    # avahi = {
    #   enable = true;
    #   nssmdns4 = true;
    # };

    printing = {
      enable = true;
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
