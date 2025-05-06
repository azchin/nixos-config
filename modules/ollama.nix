{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  options = {
    myOllama.enable = lib.mkEnableOption "myOllama";
  };
  
  config = lib.mkIf config.myOllama.enable {
    # https://github.com/ollama/ollama/blob/main/docs/gpu.md#amd-radeon
    # rocminfo | grep gfx
    services.ollama = {
      enable = true;
      acceleration = "rocm"; 
      rocmOverrideGfx = "11.0.0";
    };
  };
}
