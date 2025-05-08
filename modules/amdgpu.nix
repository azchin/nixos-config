{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  options = {
    myAmdgpu.enable = lib.mkEnableOption "myAmdgpu";
  };
  
  config = lib.mkIf config.myAmdgpu.enable {
    hardware.amdgpu.opencl.enable = true;
    
    myPackages = with pkgs-unstable; [
      rocmPackages.rocminfo
      amdgpu_top
    ];
  };
}
