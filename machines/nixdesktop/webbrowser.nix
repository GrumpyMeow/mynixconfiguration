{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in

{


  programs.chromium = {
    enable = true;
    homepageLocation = "https://${vars.publicDomain}:8123";
    extraOpts = { 
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [
        "nl"
        "en-US"
      ];
    };
    initialPrefs = {
      "homepage" = "https://${vars.publicDomain}:8123";
      "browser" = {
        "show_home_button" = true;
      };
      "bookmark_bar" = {
        "show_on_all_tabs" = true;
      };
      "sync_promo" = {
        "show_on_first_run_allowed" = false;
      };
      "first_run_tabs" = [
        "https://${vars.publicDomain}:8123"
      ];
    };
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden Password Manager
    ];
    enablePlasmaBrowserIntegration = true;
  };

  environment.systemPackages = with pkgs; [
    pkgs.chromium
  ];  


}
