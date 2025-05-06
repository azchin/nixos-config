{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  imports = [
    ../../configuration.nix
  ];

  # Define your hostname.
  networking.hostName = "nixtwo";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure custom modules
  nixtwoNetwork.enable = true;
  myWireguard.enable = true;
  myWireguard.mode = "devices";
  myLaptop.enable = true;
  myAwesomewm.enable = false;
  myHypr.enable = true;
  myX11.dpi = 138;
  myCursorSize = 36;
  myGaming.enable = false;
  
  # Hardware configuration
  nixtwoHardware.enable = true;

  # Bootloader
  myEFI.enable = true;

  # Graphics
  myAmdgpu.enable = true;
  # TODO https://github.com/ollama/ollama/pull/6282
  myOllama.enable = false;
  services.ollama = {
    rocmOverrideGfx = lib.mkForce "11.5.2";
    environmentVariables = {
      OLLAMA_MAX_LOADED_MODELS = "1";
      OLLAMA_NUM_PARALLEL = "1";
    };
  };

  # Install programs specific for this host
  # environment.systemPackages = with pkgs; [
  # ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
