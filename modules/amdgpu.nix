{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myAmdgpu.enable = lib.mkEnableOption "myAmdgpu";
  };
  
  config = lib.mkIf config.myAmdgpu.enable {
    # Overclock
    boot.extraModprobeConfig = ''
      options amdgpu ppfeaturemask=0xfffd7fff
    '';
    
    hardware.graphics.enable = true;
    hardware.amdgpu.opencl.enable = true;
    
    # https://github.com/ollama/ollama/blob/main/docs/gpu.md#amd-radeon
    services.ollama = {
      enable = true;
      package = pkgs-stable.ollama; # FIXME https://github.com/NixOS/nixpkgs/pull/373234
      acceleration = "rocm"; 
      rocmOverrideGfx = "11.0.0";
    };

    myPackages = with pkgs; [
      rocmPackages.rocminfo
      amdgpu_top
    ];
  };
}
