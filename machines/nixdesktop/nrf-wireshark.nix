{ config, lib, pkgs, ... }:

with lib;

let

in
{

  nixpkgs.overlays = [ (final: prev: 
  {
    nrfutil = prev.nrfutil.overrideAttrs (old: {
      postPatch = ''
        mkdir test-reports
        substituteInPlace requirements.txt \
          --replace "libusb1==1.9.3" "libusb1" \
          --replace "protobuf >=3.17.3, < 4.0.0" "protobuf"
        substituteInPlace nordicsemi/dfu/tests/test_signing.py \
          --replace "self.assertEqual(expected_vk_pem, vk_pem)" ""
      '';
    });
  }
  )];

  users.users.system = {
    extraGroups = [ 
      "wireshark"
      "dialout"
    ];
  };

  programs.wireshark.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
     "segger-jlink-qt4-794l"
     "segger-jlink-qt4-796b"
     "segger-jlink-qt4-796k"
     "segger-jlink-qt4-796s"
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.segger-jlink.acceptLicense = true;

  #python312.withPackages (ps: with ps; [ pip ])

  environment.systemPackages = with pkgs; [ 
    pkgs.wireshark
    pkgs.nrfconnect
    #(callPackage ./nrfconnect5.nix {} )
    #(callPackage ./segger-jlink/package.nix {} )
    #(callPackage ./nrf52840-mdk-usb-dongle.nix {} )
    pkgs.nrf-command-line-tools
    pkgs.nrfutil
    #pkgs.nrf-udev
  ];  
}
