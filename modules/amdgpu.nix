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
      # FIXME https://github.com/NixOS/nixpkgs/issues/376930
      # FIXME https://github.com/NixOS/nixpkgs/pull/373234
      # package = pkgs-stable.ollama;
      acceleration = "rocm"; 
      rocmOverrideGfx = "11.0.0";
    };

    myPackages = with pkgs; [
      rocmPackages.rocminfo
      amdgpu_top
    ];
  };
}
