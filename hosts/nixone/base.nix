{ config, lib, pkgs, pkgs-stable, ... }:

{
  imports = [
    ../../configuration.nix
  ];

  # Define your hostname.
  networking.hostName = "nixone";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure custom modules
  myDesktop.enable = true;
  nixoneNetwork = {
    enable = true;
    dnsOnly = false;
  };
  myAwesomewm.enable = true;
  myX11.dpi = 138;
  myCursorSize = 36;

  services.xserver.xrandrHeads = [ 
    {
      output = "DP-2";
      # monitorConfig = "DisplaySize 338 190\nOption \"LeftOf DP-3\"";
    }
    {
      output = "DP-1";
      primary = true;
    }
  ];

  services.autorandr = {
    enable = true;
    defaultTarget = "dual";
    profiles = {
      "dual" = {
        fingerprint = {
          DP-2 = "00ffffffffffff003669b5400000000015220104a5351d783bb705ad564d99260d5054bfcf00714f81c0818081009500b300d1c00101023a801871382d40582c450012222100001e000000fc004d5349204d50323433580a2020000000fd0030645d5d21010a202020202020000000ff0050423548343034353032323137011202031e7448900102030412131f2309070783010000681a000001013064002a4480a0703827403020350012222100001aeb5a80a0703827403020350012222100001e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070";
          DP-1 = "00ffffffffffff0010ac4ed1564d433010210104b5462878fb1285ac5049a627125054a54b00a9c0b300d100714fa9408180d1c001014dd000a0f0703e8030203500b9882100001a000000ff00395256584b4b330a2020202020000000fc0044454c4c20534533323233510a000000fd00283c8c8c3c010a20202020202001ce020324f14e61040302011211131f105d5e5f602309070783010000681a00000101283ce6565e00a0a0a0295030203500b9882100001a023a801871382d40582c4500b9882100001e47a90050f070338008205808b9882100001a000000000000000000000000000000000000000000000000000000000000000000000000002a";
        };
        config = {
          DP-2 = {
            enable = true;
            mode = "1920x1080";
            position = "0x0";
            rate = "100.00";
            scale = {
              x = 1.5;
              y = 1.5;
            };
            # dpi = 96;
          };
          DP-1 = {
            enable = true;
            primary = true;
            mode = "3840x2160";
            position = "1920x0";
            rate = "60.00";
            # dpi = 144;
          };
        };
      };
    };
  };

  myGaming.enable = true;
  
  # Hardware configuration
  nixoneHardware.enable = true;
  nixoneHardwareExtra.enable = true;

  # Bootloader
  myEFI.enable = true;

  # Graphics
  myAmdgpu.enable = true;
  
  # Install programs specific for this host
  environment.systemPackages = with pkgs; [
    btrfs-progs
    ntfs3g
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
