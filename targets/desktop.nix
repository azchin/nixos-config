{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myDesktop.enable = lib.mkEnableOption "myDesktop";
  };
  
  config = lib.mkIf config.myDesktop.enable {
    myUser.enable = true;
    myGraphical.enable = true;
    myPackages = with pkgs; [
      geekbench
    ];
  };
}
