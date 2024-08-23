{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{ 

#  systemd.services.frigate = {
#    environment.LIBVA_DRIVER_NAME = "radeonsi";
#    serviceConfig = {
#      SupplementaryGroups = ["render" "video"] ; # for access to dev/dri/
#      AmbientCapabilities = "CAP_PERFMON";
#    };
#  };

  disabledModules = [ "services/video/frigate.nix" "applications/video/frigate/default.nix"];

  environment.systemPackages = [ 
    pkgs.cifs-utils
    (pkgs.callPackage ./frigate/default.nix {})
  ];

  

  imports = [
     ./frigate/frigate.nix
  ];
  
  fileSystems."/var/lib/frigate/recordings" = {
    device = "//hub.${vars.domain}/media/Frigate/recordings"; 
    fsType = "cifs";
     #
    options = [      
      "uid=990"
      "gid=988"
      #"guest"
      "nofail"
      "noauto"
      "rw"
      "rsize=16777216"
      "cache=loose"
      "x-systemd.after=network.target"
    ];
  };

  networking.firewall = {
    checkReversePath = "loose";
    interfaces.eth0 = {
      allowedTCPPorts = [ 5000 5001 5002 8082 8554 8555 1984 ];
    };
  };

  fileSystems."/var/cache/frigate" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
  };

  systemd.tmpfiles.rules = [
      "d /dev/shm/logs/nginx/ 0777 frigate frigate -"
      "d /dev/shm/logs/go2rtc/ 0777 frigate frigate -"
      "d /dev/shm/logs/frigate/ 0777 frigate frigate -"
      "f /dev/shm/logs/nginx/current 0777 frigate frigate -"
      "f /dev/shm/logs/go2rtc/current 0777 frigate frigate -"
      "f /dev/shm/logs/frigate/current 0777 frigate frigate -"
  ];

  services.go2rtc = {
    enable = true;
    settings = {
      api = { 
        origin = "*";
      };      
      rtsp.listen = ":8554";
      webrtc.listen = ":8555";
      streams = {
        voortuin = [
          "rtsp://admin:${vars.myPassword}@${vars.subnetPrefixIP}.78:554/ch01.264?dev=1"
          "ffmpeg:voortuin#audio=opus"
        ];
        deurbel = [
          "ffmpeg:http://${vars.subnetPrefixIP}.63/flv?port=1935&app=bcs&stream=channel0_main.bcs&user=admin&password=${vars.myPassword}#video=copy#audio=copy#audio=opus"
          "rtsp://${vars.subnetPrefixIP}.63/Preview_01_sub"
        ];
      };
      ffmpeg = {
        volume = ''-af "volume=30dB"'';
      };
    };
  };

  services.frigate = {
    enable = true;
    hostname = "frigate";
    settings = {
      ui = {
        timezone = vars.timezone;
        live_mode = "mse";
        date_style = "medium";
      };
      logger = {
        default = "error";
      #  logs = [
      #    "frigate.mqtt" = "critical";
      #  ];
      };
      mqtt = { 
        enabled = true;
        host = "${vars.mqttServerHostName}.${vars.domain}"; # not working dns
        port = vars.mqttPort;
        client_id = "frigate";
        stats_interval = 60;
        topic_prefix = "frigate";
      };

      go2rtc = {
        streams = {
          voortuin = [
            "rtsp://admin:${vars.myPassword}@${vars.subnetPrefixIP}.78:554/ch01.264?dev=1"
            "ffmpeg:voortuin#audio=opus"
          ];
          deurbel = [
            "ffmpeg:http://${vars.subnetPrefixIP}.63/flv?port=1935&app=bcs&stream=channel0_main.bcs&user=admin&password=${vars.myPassword}#video=copy#audio=copy#audio=opus"
            "rtsp://${vars.subnetPrefixIP}.63/Preview_01_sub"
          ];
        };
        ffmpeg = {
          volume = ''-af "volume=30dB"'';
        };
      };

      #ffmpeg.hwaccel_args = "preset-vaapi";
      cameras = {
        voortuin = {
          ffmpeg = {
            output_args = {
              record = "preset-record-generic";
            };
            inputs = [ {
              path = "rtsp://127.0.0.1:8554/voortuin";
              input_args = "preset-rtsp-restream";
              roles = [
                "record"
                "detect"
              ];
            } ];
          };

          detect = {
            enabled = true; 
            width = 1280;
            height = 720;
            fps = 5;          
            stationary = {
              interval = 50;
              threshold = 10;
            };
          };

          live = {
            stream_name = "voortuin";
            height = 1440;
          };

          motion = {
            threshold = 60;
            contour_area = 30;
            frame_alpha = 0.1;
            lightning_threshold = 0.6;
            mask = [
              "1280,0,1280,720,1034,720,1206,347,1116,23,314,21,134,334,422,720,0,720,0,0"
              "426,720,749,299,744,117,586,139,145,483" 
              "1180,353,1142,140,846,114,884,344"
            ];
          };

          objects = {
            mask = "1280,0,1280,720,1034,720,1206,347,1116,23,314,21,134,334,422,720,0,720,0,0";
            track = [
              "person"
              "dog"
              "cat"
              "bicycle"
              "package"
            ];
          };

          record = {
            enabled = true;
            events = {
              pre_capture = 5;
              post_capture = 20;
              retain = {
                default = 2;
                mode = "motion";
              };
            };
          };

          snapshots = {
            enabled = true;
          };

          audio = {
            enabled = false;
          };

        };
        deurbel = {
          ffmpeg = {
            output_args = {
              record = "preset-record-generic-audio-copy";
            };
            inputs = [ {
              path = "rtsp://127.0.0.1:8554/deurbel";
              input_args = "preset-rtsp-restream";
              roles = [
                "record"
                "detect"
                "audio"
              ];
            } ];
          };
          audio = {
           enabled = true;
           min_volume = 80;
           listen = [ 
             "bark"
             "fire_alarm"
             "scream"
             "speech"
             "yell"
             "whisper"
             "babbling"
             "crying"
             "whistling"
             "cough"
             "run"
             "throat_clearing"
             "footsteps"
             "finger_snapping"
             "children_playing"
             "dog"
             "meow"
             "honk"
             "dogs"
             "thunder"
             "car_alarm"
             "reversing_beeps"
             "emergency_vehicle"
             "police_car"
             "ambulance"
             "fire_engine"
             "door"
             "doorbell"
             "ding-dong"
             "alarm"
             "smoke_detector"
             "siren"
             "whistle"
             "explosion"
             "gunshot"
             "shatter"
             "breaking"
           ];
          };

          detect = {
            enabled = true; 
            width = 1280;
            height = 960;
            fps = 5;
          };

          live = {
            stream_name = "deurbel";
            height = 1920;
          };

          motion = {
            threshold = 100;
            mask = [
              "0,960,0,0,1280,0,1280,960,949,960,1000,624,766,598,773,536,659,527,602,553,605,644,200,727,269,960"
            ];
          };

          objects = {
            mask = [
              "0,960,0,0,1280,0,1280,960,949,960,1000,624,766,598,773,536,659,527,602,553,605,644,200,727,269,960"
            ];
            track = [
              "person"
              "dog"
              "cat"
              "package"
            ];
          };

          record = {
            enabled = true;
            retain = {
              days = 2;
              mode = "motion";
            };

            events = {
              pre_capture = 5;
              post_capture = 60;
              retain = {
                default = 2;
                mode = "motion";
                objects = {
                  person = 2;
                  speech = 2;
                };
              };
            };

          };

          snapshots = {
            enabled = true;
          };
        };
      };
    
      telemetry = { version_check = false; };
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts = {
      "frigate_" = {
        useACMEHost = vars.publicDomain;
        http2 = true;
        serverName = "frigate.${vars.publicDomain}";
        forceSSL = true;
        extraConfig = ''
          send_timeout 100m;
          proxy_redirect off;
          proxy_buffering off;
        '';        
        locations."/" = {
          proxyPass = "http://127.0.0.1:5000";
          proxyWebsockets = true;
        };
      };

      "frigate" = {       
        http2 = true;
        forceSSL = false;
        enableACME = false;
        listen = [{port = 5000;  addr="0.0.0.0"; ssl = false;}];
      };
    };
  };

}
# https://github.com/averyanalex/nixcfg/blob/9059df25c326465f0d083705e5a462794edf628f/machines/lizard/frigate.nix#L4
# ffmpeg.hwaccel_args = "preset-vaapi";

#https://ryantm.github.io/nixpkgs/using/overrides/
