{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
in
{  
   
#  environment.sessionVariables = rec {
#    HSA_OVERRIDE_GFX_VERSION = "9.0.0";
#    HCC_AMDGPU_TARGETS = "gfx900";
#    PYTORCH_ROCM_ARCH = "gfx900";
#    USE_ROCM = 1;
#  };

  services.ollama = {
    enable = true;
#    listenAddress = "0.0.0.0:11434";
    acceleration = "rocm";
    sandbox = false;
    environmentVariables = {
#      ROC_ENABLE_PRE_VEGA = "1";
#      HCC_AMDGPU_TARGETS = "gfx900";
#      HIP_VISIBLE_DEVICES = "0";
      HSA_OVERRIDE_GFX_VERSION = "9.0.0";
      OLLAMA_DEBUG = "true";
    };
  };

  hardware.amdgpu.opencl.enable = true;

#  hardware.graphics.extraPackages = [
#    pkgs.rocm-opencl-icd
#  ];

#  hardware.graphics.extraPackages = [
#    pkgs.rocmPackages.clr.icd
#  ];


  environment.systemPackages = with pkgs; [    
    pkgs.rocmPackages.rocminfo
    pkgs.rocmPackages.rocm-smi
  ];
}
