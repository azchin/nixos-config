{ config, lib, pkgs-unstable, pkgs-stable, pkgs-pwndbg, ... }:

with lib; {
  options = with types; {
    myGraphical.enable = mkEnableOption "myGraphical";
    myPackages = mkOption {
      type = listOf package;
      description = "List of my packages";  
      default = [];
    };
  };
  
  config = mkMerge [
    ({
      myPackages = with pkgs-unstable; [
        # CLI tools start here
        htop
        btop
        neofetch
        tree
        bc
        file
        git
        git-lfs
        git-extras
        tmux
        ripgrep
        fd
        tealdeer
        tokei
        fzf
        bat
        gdu
        psmisc
        sshpass
        pass
        zip
        unzip
        p7zip
        yq
        jq
        gdb
        grpcurl
        (python3.withPackages (p: with p; [
          pip
          virtualenv
          pygments
          pwntools
          ropper
          numpy
          scipy
          pandas
          pipx
          llm
          llm-ollama 
          llm-cmd
          pyyaml
          python-lsp-server
          jinja2
          jsonschema
          # ruff
          # python-lsp-ruff
          # uv
          # TODO figure out how to package these things
          # llm-cmd-comp
          # llm-python
          # llm-jq
        ]))
        # Build systems
        man
        man-pages
        poppler_utils
        texliveFull
        ghostscript
        gcc
        cmake
        gnumake
        ninja
        meson # apparently this is nice?
        pkg-config
        # pyright
        ccls
        ruff
        bear
        pnpm
        protobuf
        uv
        # Alternative is to use https://github.com/oxalica/rust-overlay
        rustup
        go
        # nix
        nh
        nix-output-monitor
        # libraries
        openssl
        # More utilities
        qemu
        quickemu
        spice
        spice-gtk
        gnupg
        pcsclite
        # vagrant
        gocryptfs
        distrobox
        expect
        inotify-tools
        nmap
        inetutils
        lynx
        sqlite
        foremost
        inxi
        eza
        yt-dlp
        ffmpeg-full
        imagemagick
        potrace
        hunspell
        hunspellDicts.en-us
        hunspellDicts.en-ca
        yubikey-manager
        yubioath-flutter
        nvimpager
        httpie
        insomnia
        appimage-run
        aider-chat
        claude-code
        # Security tools
        pkgs-pwndbg.default
        dig
        tcpdump
        nikto
        aflplusplus
        # System utilities
        mprime
        lm_sensors
        resources
        brightnessctl
        # TODO sensors -j into a grapher
        cpu-x
        linuxPackages.cpupower
        nvme-cli
        smartmontools
        pciutils
        libva-utils
        glxinfo
        usbutils
        speedtest-cli
        acpi
        sysfsutils
        dmidecode
        ntfs3g
        dosfstools
        qmk
        ethtool
        android-udev-rules
      ];

      myDocker.enable = mkDefault true;
      myFirefox.enable = mkDefault true; # for headless

      programs.gnupg.agent = {
        enable = true;
        pinentryPackage = pkgs-unstable.pinentry-tty;
      };

      # yubikey
      # https://github.com/Yubico/libu2f-host/blob/master/70-u2f.rules
      services.pcscd.enable = true;
      services.udev.extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120|0121|0200|0402|0403|0406|0407|0410", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      '';

      programs.ssh.startAgent = true;
      services.spice-vdagentd.enable = true;
      programs.mosh.enable = true;

      # SBOM
      environment.etc."current-packages".text =
        let
          packages = builtins.map (p: "${p.name}")
            (config.environment.systemPackages ++ config.users.users.${config.myUser.primary}.packages);
          sortedUnique = builtins.sort builtins.lessThan (pkgs-unstable.lib.lists.unique packages);
          formatted = builtins.concatStringsSep "\n" sortedUnique;
        in
          formatted;

      # FIXME remove
      # myHomeManager.enable = mkDefault true;
    })
    (mkIf config.myGraphical.enable {
      myPackages = with pkgs-unstable; [
        # Graphical apps
        alacritty
        keepassxc
        nextcloud-client
        guvcview
        nsxiv
        mpv
        transmission_4-gtk
        brave
        signal-desktop
        audacity
        zotero
        slack
        spotify
        pavucontrol
        libreoffice-fresh
        kdePackages.okular
        digikam
        krita
        neovide
        inkscape
        musescore
        reaper
        kdePackages.kdenlive
        ghidra
        stremio
        discord-canary
        kooha
        easyeffects
        vscode
        code-cursor
        logseq
        # Things to try later
        # reaper
        # xournalpp
        # calcurse
        # gopls
      ];

      # Custom modules
      myFcitx.enable = mkDefault true;
      myVirtualbox.enable = mkDefault false;
      myKwallet.enable = mkDefault true;
      myDisplayManager = mkDefault "ly";
    
      programs.wireshark.enable = true;
      myUser.extraGroups = [ "wireshark" ];

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs-unstable.obs-studio-plugins; [
          obs-composite-blur
          obs-backgroundremoval
        ];
      };
    
      services.psd.enable = true;
      services.transmission = {
        enable = true;
        package = pkgs-unstable.transmission_4;
        openPeerPorts = true;
      };
      systemd.services.transmission = {
        enable = false;
      };
  
      fonts.packages = with pkgs-unstable; [
        dejavu_fonts
        noto-fonts-cjk-serif
        noto-fonts-cjk-sans
        nerd-fonts.dejavu-sans-mono
        nerd-fonts.fira-code
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
        extraPortals = with pkgs-unstable; [
          xdg-desktop-portal-gtk
        ];
        config.common.default = "gtk";
      };

      # TODO home manager?
      # dconf write /org/gnome/desktop/interface/cursor-theme "'THEME_NAME'"
      programs.dconf = {
        enable = true;
        profiles.user.databases = [
          {
            settings = {
              "org/gnome/desktop/interface" = { cursor-theme = "capitaine-cursors-white"; };
              "org/gnome/desktop/wm/preferences" = { button-layout = ""; };
            };
          }
        ];
      };

      hardware.graphics.enable = true;

      # Enable sound.
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        pulse.enable = true;
        # jack.enable = true; # messes up ld_library_path
        wireplumber.enable = true;
      };

      # Enable touchpad support (enabled default in most desktopManager).
      services.libinput.enable = true;

      # Pick only one of the below networking options.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
      networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

      # sudo
      security = {
        sudo = {
          enable = false;
          wheelNeedsPassword = false;
        };
        sudo-rs = {
          enable = true;
          wheelNeedsPassword = false;
        };
      };

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

    })
  ];
}
