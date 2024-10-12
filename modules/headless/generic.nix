{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
  time.timeZone = vars.timezone;

  nixpkgs.config = { 
    allowUnfree = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "nl_NL.UTF-8";

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 1d";
  };

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  # Don't ask for passwords
  security.sudo.wheelNeedsPassword = false;

  security.pam.services.sshd.allowNullPassword = true;

  # Enable ssh
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "yes";
      PermitEmptyPasswords = "yes";
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
    };
  };
  programs.ssh.startAgent = true;

  environment.systemPackages = with pkgs; [
    pkgs.wget
    pkgs.dig # NSLookup etc.
    pkgs.nmap
    pkgs.traceroute
    pkgs.inetutils
    pkgs.git
    pkgs.gh
    pkgs.nano 
    pkgs.man pkgs.man-pages pkgs.man-pages-posix
  ];  


}


