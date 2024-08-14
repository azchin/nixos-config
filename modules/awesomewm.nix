{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myAwesomewm.enable = lib.mkEnableOption "myAwesomewm";
  };
  
  config = lib.mkIf config.myAwesomewm.enable {
    myX11.enable = true;

    services.xserver.windowManager.awesome = {
      enable = true;
      package = (pkgs.awesome.overrideAttrs (oldAttrs: rec {      
        src = pkgs.fetchFromGitHub {
          owner = "awesomeWM";
          repo = "awesome";
          rev = "ad0290bc1aac3ec2391aa14784146a53ebf9d1f0";
          sha256 = "sha256-uaskBbnX8NgxrprI4UbPfb5cRqdRsJZv0YXXshfsxFU=";
        }; 
        patches = [];
        postPatch = ''
          patchShebangs tests/examples/_postprocess.lua
        '';
      })).override {
        gtk3Support = true;
      };    
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };
  };
}
