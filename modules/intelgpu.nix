{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  options = {
    myIntelgpu.enable = lib.mkEnableOption "myIntelgpu";
  };
  
  config = lib.mkIf config.myIntelgpu.enable {
    environment.systemPackages = with pkgs-unstable; [
      intel-gpu-tools
    ];
  };
}
