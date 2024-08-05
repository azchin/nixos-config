{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myAmdgpu.enable = lib.mkEnableOption "myAmdgpu";
  };
  
  config = lib.mkIf config.myAmdgpu.enable {
    # Early load
    hardware.amdgpu.initrd.enable = true;
  
    # Overclock
    boot.extraModprobeConfig = ''
      options amdgpu ppfeaturemask=0xfffd7fff
    '';
    
    environment.systemPackages = with pkgs; [
      amdgpu_top
    ];
  };
}
