{ config, lib, pkgs, pkgs-stable, ... }:

with lib; {
  options = with types; {
    myGraphical.enable = mkEnableOption "myGraphical";
    myPackages = mkOption {
      type = listOf package;
      description = "List of my packages";  
      default = [];
    };
  };
  
  config = mkIf config.myGraphical.enable {
    myPackages = with pkgs; [
      # CLI tools start here
      htop
      btop
      neofetch
      tree
      bc
      file
      git
      tmux
      ripgrep
      fd
      tealdeer
      ncdu
      psmisc
      zip
      unzip
      yq
      jq
      gcc
      cmake
      gnumake
      ninja
      python3
      man
      man-pages
      texliveFull
      ghostscript
      # for rust, follow rustup instructions for devshell https://nixos.wiki/wiki/Rust
      cargo
      rustc
      # Graphical apps
      alacritty
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
      brave
      signal-desktop
      audacity
      zotero
      slack
      spotify
      pavucontrol
      libreoffice-fresh
      kdePackages.okular
      calcurse
      nvimpager
      vagrant
      # Security tools
      ghidra
      gdb
      pwndbg
      pwntools
      dig
      tcpdump
      # System utilities
      mprime
      lm_sensors
      cpu-x
      linuxPackages.cpupower
      pciutils
      libva-utils
      glxinfo
    ];

    # Custom modules
    myFirefox.enable = mkDefault true;
    myFcitx.enable = mkDefault true;
    myDocker.enable = mkDefault true;
    
    programs.wireshark.enable = true;
    myUser.extraGroups = [ "wireshark" ];

    myVirtualbox.enable = mkDefault true;
    
    services.psd.enable = true;
    services.transmission = {
      enable = true;
      package = pkgs.transmission_4;
      openPeerPorts = true;
    };
    systemd.services.transmission = {
      enable = false;
    };
  
    fonts.packages = with pkgs; [
      dejavu_fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
    ];
    fonts.enableDefaultPackages = true;

    xdg.icons.enable = true;
    xdg.menus.enable = true;
    xdg.sounds.enable = false;
    xdg.mime = {
      enable = true; 
      defaultApplications = {
        "application/pdf" = "org.kde.okular.desktop";
        "text/plain" = [ "emacs-client.desktop" "emacs.desktop" ];
        "text/markdown" = [ "emacs-client.desktop" "emacs.desktop" ];
        "image/png" = "nsxiv.desktop";
        "image/jpeg" = "nsxiv.desktop";
        "image/svg+xml" = "nsxiv.desktop";
        "image/apng" = "nsxiv.desktop";
        "image/avif" = "nsxiv.desktop";
        "image/bmp" = "nsxiv.desktop";
        "image/vnd.microsoft.icon" = "nsxiv.desktop";
        "image/tiff" = "nsxiv.desktop";
        "image/webp" = "nsxiv.desktop";
        "audio/aac" = "mpv.desktop";
        "audio/midi" = "mpv.desktop";
        "audio/x-midi" = "mpv.desktop";
        "audio/mpeg" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "audio/wav" = "mpv.desktop";
        "audio/webm" = "mpv.desktop";
        "audio/3gpp" = "mpv.desktop";
        "audio/3gpp2" = "mpv.desktop";
        "video/x-msvideo" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
        "video/ogg" = "mpv.desktop";
        "video/mp2t" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/3gpp" = "mpv.desktop";
        "video/3gpp2" = "mpv.desktop";
      };
    };
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      config.common.default = "gtk";
    };

    programs.dconf.enable = true;
    programs.gnupg.agent = {
      # NOTE touch ~/.gnupg/gpg-agent.conf and mkdir ~/.local/share/gnupg mode 700
      enable = true;
      pinentryPackage = pkgs.pinentry-tty;
    };

    hardware.graphics.enable = true;

    # Enable sound.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

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

    # NOTE allow unfree is configured at flake level
    # nixpkgs.config.allowUnfree = true;

    # nixpkgs.overlays = [
    #   (final: prev: {
    #     awesome = prev.awesome.override { gtk3Support = true; };
    #   })
    # ];

    # systemd.coredump.extraConfig = "Storage=none\nProcessSizeMax=0";

    # services = {
    #   displayManager.sddm.enable = true;
    #   desktopManager.plasma6.enable = true;
    # };

    # Configure keymap in X11
    # services.xserver.xkb.layout = "us";
    # services.xserver.xkb.options = "eurosign:e,caps:escape";

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # TODO kwallet after NixOS fixes PAM https://github.com/NixOS/nixpkgs/issues/258296
  
    # NOTE still need to set up .xprofile and xrdb

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

  };
}
