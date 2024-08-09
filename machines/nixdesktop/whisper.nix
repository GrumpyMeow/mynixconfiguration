{ config, lib, pkgs, ... }:

with lib;

let

in

{

  environment.systemPackages = with pkgs; [    
    pkgs.openai-whisper
  ];

}
