{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myIntelgpu.enable = lib.mkEnableOption "myIntelgpu";
  };
  
  config = lib.mkIf config.myIntelgpu.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        linux-firmware
      ];
      extraPackages32 = with pkgs; [
        intel-media-driver
        linux-firmware
      ];
    };
    environment.systemPackages = with pkgs; [
      intel-gpu-tools
    ];
  };
}
