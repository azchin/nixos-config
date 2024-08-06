{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myDesktop.enable = lib.mkEnableOption "myDesktop";
  };
  
  config = lib.mkIf config.myDesktop.enable {
    myUser.enable = true;
    myUser.primary.extraPackages = with pkgs; [
      geekbench
    ];
  };
}
