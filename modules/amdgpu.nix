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
    
    services.ollama = {
      acceleration = "rocm"; 
      rocmOverrideGfx = "11.0.0";
    };
    
    environment.systemPackages = with pkgs; [
      amdgpu_top
    ];
  };
}
