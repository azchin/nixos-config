{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myDesktop.enable = lib.mkEnableOption "myDesktop";
  };
  
  config = lib.mkIf config.myDesktop.enable {
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    # Custom modules
    myX11.enable = lib.mkDefault true;
    myFirefox.enable = lib.mkDefault true;
    myFcitx.enable = lib.mkDefault true;

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

    # Enable sound.
    # hardware.pulseaudio.enable = true;
    # OR
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    hardware.graphics.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;
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
  
    users.groups.andrew.gid = 1000;
  
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.andrew = {
      isNormalUser = true;
      uid = 1000;
      group = "andrew";
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.zsh;
      packages = with pkgs; [
        alacritty
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
        # stremio
        pavucontrol
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
        pinentry
        # for rust, follow rustup instructions for devshell https://nixos.wiki/wiki/Rust
        # CLI tools end here
      ];
    };

    xdg.mime.enable = true;
    xdg.menus.enable = true;
    xdg.sounds.enable = false;

    programs.zsh.enable = true;
    programs.dconf.enable = true;
    programs.gnupg.agent = {
      # NOTE touch ~/.gnupg/gpg-agent.conf and mkdir ~/.local/share/gnupg mode 700
      enable = true;
      pinentryPackage = pkgs.pinentry-tty;
    };

    security.sudo.wheelNeedsPassword = false;

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