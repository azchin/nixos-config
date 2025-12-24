{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  options = {
    myNiri.enable = lib.mkEnableOption "myNiri";
  };
  
  config = lib.mkIf config.myNiri.enable {
    myMinimal.enable = true;
    myGraphical.enable = true;
    myWayland.enable = true;

    programs.niri.enable = true;

    # TODO lock, cursor, wallpaper, idle
    myPackages = with pkgs-unstable; [
      xwayland-satellite
    ];
  };
}
