{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myIntelgpu.enable = lib.mkEnableOption "myIntelgpu";
  };
  
  config = lib.mkIf config.myIntelgpu.enable {
    hardware.graphics.enable = true;

    environment.systemPackages = with pkgs; [
      intel-gpu-tools
    ];
  };
}
