# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, pkgs-stable, ... }:

{
  imports =
    [
      ./private/networking.nix
      ./private/hardware-configuration.nix
      ./private/hardware-extra.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixone"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "daily";
  };

  # NOTE allow unfree is configured at flake level
  # nixpkgs.config.allowUnfree = true;

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     awesome = prev.awesome.override { gtk3Support = true; };
  #   })
  # ];

  # systemd.coredump.extraConfig = "Storage=none\nProcessSizeMax=0";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    dpi = 144;
    upscaleDefaultCursor = true;
    autoRepeatInterval = 25;
    autoRepeatDelay = 400;
  };

  services.xserver.displayManager.lightdm.greeters.gtk = {
    enable = true;
    theme = {
      name = "Arc-Darker";
      package = pkgs.arc-theme;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "capitaine-cursors-white";
      package = pkgs.capitaine-cursors;
      size = 36;
    };
    indicators = [
      "~host"
      "~spacer"
      "~clock"
      "~spacer"
      "~session"
      "~a11y"
      "~power"
    ];
    clock-format = "%F %T %Z";
  };

  services.xserver = {
   windowManager.awesome = {
     enable = true;
     package = pkgs.awesome.overrideAttrs (old: {      
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
       });    
       luaModules = with pkgs.luaPackages; [
         luarocks # is the package manager for Lua modules
         luadbi-mysql # Database abstraction layer
       ];
     };
   };

  # services = {
  #   displayManager.sddm.enable = true;
  #   desktopManager.plasma6.enable = true;
  # };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.gvfs.enable = true;
  services.psd.enable = true;

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    openPeerPorts = true;
  };
  
  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans
    (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
  ];
  fonts.enableDefaultPackages = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andrew = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      # nixpkgs-stable.legacyPackages.x86_64-linux.firefox
      alacritty
      emacs-gtk
      sshfs
      neovide
      keepassxc
      nextcloud-client
      guvcview
      nsxiv
      mpv
      yt-dlp
      ffmpeg
      imagemagick
      transmission_4-gtk
      hunspell
      hunspellDicts.en-us
      hunspellDicts.en-ca
      yubikey-manager
      profile-sync-daemon
      brave
      signal-desktop
      audacity
      zotero
      slack
      spotify
      stremio
      # X11 window manager
      xorg.xrdb
      xorg.xset
      xorg.xsetroot
      xclip
      dunst
      picom
      networkmanagerapplet
      xss-lock
      xsecurelock
      playerctl
      pamixer
      maim
      pavucontrol
      arc-theme
      papirus-icon-theme
      capitaine-cursors
      kdePackages.breeze
      libsForQt5.breeze-qt5
      kdePackages.okular
      kdePackages.oxygen-icons
      pcmanfm
      lxmenu-data
      shared-mime-info
      # X11 ends (plus awesomewm)
      # CLI tools start here
      neofetch
      ncdu
      psmisc
      tree
      bc
      git
      tmux
      ripgrep
      fd
      tealdeer
      htop
      gcc
      pciutils
      libva-utils
      glxinfo
      gnupg
      # for rust, follow rustup instructions for devshell https://nixos.wiki/wiki/Rust
      # CLI tools end here
    ];
  };

  xdg.mime.enable = true;
  xdg.menus.enable = true;

  programs.zsh.enable = true;
  programs.dconf.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    preferences = {
      "browser.aboutConfig.showWarning" = false;
      "browser.compactmode.show" = true;
      "browser.tabs.insertAfterCurrent" = true;
      "findbar.highlightAll" = true;
      "browser.sessionstore.interval" = 600000;
      "extensions.pocket.enabled" = false;
    };
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };
  # qtct settings: DejaVu Sans (Mono) 10
  #                Breeze icons

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      plasma6Support = true;
      addons = with pkgs; [
        fcitx5-mozc
        kdePackages.fcitx5-chinese-addons
      ];
    };
  };
  
  security.sudo.wheelNeedsPassword = false;

  # TODO kwallet after NixOS fixes PAM https://github.com/NixOS/nixpkgs/issues/258296
  
  environment.variables = {
    EDITOR = "nvim";
    XCURSOR_THEME = "capitaine-cursors-white";
    XCURSOR_SIZE = "36";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    MOZ_ENABLE_WAYLAND = 0;
  };

  # NOTE still need to set up .xprofile and xrdb

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    efibootmgr
    btrfs-progs
    ntfs3g
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

