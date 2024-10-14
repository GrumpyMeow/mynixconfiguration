{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
  domain = "mail.933k.nl";
in
{  
  services.roundcube = {
     enable = true;
     configureNginx = true;
     hostName = "webmail.933k.nl";
     dicts = with pkgs.aspellDicts; [ en nl ];
     package = pkgs.roundcube.withPlugins (
        plugins: [ 
          plugins.contextmenu 
          plugins.persistent_login 
          #plugins.carddav 
        ]
     );
     plugins = [ 
      #"carddav"
      "contextmenu" 
      "archive" # Roundcube internal plugin
      "markasjunk" # Roundcube internal plugin
      "managesieve" # Roundcube internal plugin
      "newmail_notifier" # Roundcube internal plugin
      "zipdownload" # Roundcube internal plugin
      "show_additional_headers" # Roundcube internal plugin
     ];
     database = {
        username = "roundcube";
        password = "Passw0rd!";
        host = "localhost";
        dbname = "roundcube";
     };
      extraConfig = ''
        $config['archive_type'] = 'year';
        $config['imap_host'] = "mail.lan:143";
        $config['managesieve_host'] = "mail.lan:4190";
        $config['smtp_host'] = "mail.lan";
        $config['mail_domain'] = '933k.nl';
      '';
      #        $config['smtp_server'] = "933k.nl";
 #             $config['smtp_user'] = "%u"; 
#        $config['smtp_pass'] = "%p";

        #
      
      
      #    # starttls needed for authentication, so the fqdn required to match
      #    # the certificate
      #    
      
  };

  services.nginx = {
    enable = true;

    virtualHosts = {
      "webmail.933k.nl" = {
        enableACME = false;
        useACMEHost = vars.publicDomain;
        serverName = "webmail.${vars.publicDomain}";
      };

    };
  };

}

# https://github.com/evelynandrist/nix-config/blob/4a6517aeae6bcc029c49f0e9095fde1933978106/nixos/nixserver/mailserver.nix#L24