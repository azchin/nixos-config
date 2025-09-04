{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  options = {
    myOpenbox.enable = lib.mkEnableOption "myOpenbox";
  };
  
  config = lib.mkIf config.myOpenbox.enable {
    myMinimal.enable = true;
    myGraphical.enable = true;
    myX11.enable = true;

    services.xserver.windowManager.openbox.enable = true;
  };
}
