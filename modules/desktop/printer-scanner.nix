{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
  environment.systemPackages = with pkgs; [
    (pkgs.kdePackages.skanpage.override { 
      tesseractLanguages = [ "eng" "nld" ]; 
    })    
    pkgs.aspell
    pkgs.aspellDicts.nl
    pkgs.aspellDicts.en
  ];  
}
