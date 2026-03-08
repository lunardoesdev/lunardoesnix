# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set -U fish_greeting
    set -U fish_user_paths $HOME/.local/bin $HOME/.bun/bin
    ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  nix.settings.trusted-users = ["root" "@wheel"];
  nix.settings.extra-experimental-features = ["flakes" "nix-command"];

  # 1. Disable Nix Channels (Optional but Recommended)
  # This ensures there are no conflicts or fallback to old channels.
  nix.channel.enable = false;

  # 2. Pin <nixpkgs> in the Nix search path
  # This uses the 'nixpkgs' input from your flake.
  nix.nixPath = [
    "nixpkgs=${inputs.nixpkgs.outPath}"
    # You can add other paths here if you use them, e.g.,
    # "nixos-config=${config.system.build.nixos-config}"
  ];

  # Set your time zone.
  time.timeZone = "Asia/Vladivostok";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Cinnamon Desktop Environment.
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.desktopManager.cinnamon.enable = true;
  #services.xserver.desktopManager.xfce.enable = true;
  #services.desktopManager.cosmic.enable = true;
  
services = {
  desktopManager.plasma6.enable = true;
  displayManager.sddm.enable = true;
  displayManager.sddm.wayland.enable = true;

  #desktopManager.gnome.enable = true;
};

hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  settings = {
    General = {
      # Shows battery charge of connected devices on supported
      # Bluetooth adapters. Defaults to 'false'.
      Experimental = true;
      # When enabled other devices can connect faster to us, however
      # the tradeoff is increased power consumption. Defaults to
      # 'false'.
      FastConnectable = false;
    };
    Policy = {
      # Enable all controllers when they are found. This includes
      # adapters present on start as well as adapters that are plugged
      # in later on. Defaults to 'true'.
      AutoEnable = true;
    };
  };
};


  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa # Simple music player aiming to provide a nice experience for its users
    kdePackages.kdepim-runtime # Akonadi agents and resources
    kdePackages.kmahjongg # KMahjongg is a tile matching game for one or two players
    kdePackages.kmines # KMines is the classic Minesweeper game
    kdePackages.konversation # User-friendly and fully-featured IRC client
    kdePackages.kpat # KPatience offers a selection of solitaire card games
    kdePackages.ksudoku # KSudoku is a logic-based symbol placement puzzle
    kdePackages.ktorrent # Powerful BitTorrent client
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.satori = {
    isNormalUser = true;
    description = "satori";
    extraGroups = [ 
      "networkmanager" "wheel" 
      "adbusers" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    shell = pkgs.fish;
  };

  # services.udev.packages = [
  #   pkgs.android-udev-rules
  # ];

  #programs.adb.enable = true;
  #programs.starship.enable = true;

  programs.throne.enable = true;
  programs.throne.tunMode.enable = true;
  programs.throne.tunMode.setuid = true;

  # Install firefox.
  programs.firefox.enable = true;
  programs.amnezia-vpn.enable = true;

  #environment.variables.QT_FONT_DPI = "122";

  #services.convos = {
  #  enable = true;
  #  listenAddress = "127.0.0.1";
  #  listenPort = 9201;
  #};

  services.quassel.enable = true;
  

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    keepassxc
    tealdeer
    nodejs_25
    nix-search-cli
    zed-editor
    recoll
    #brave
    ungoogled-chromium
    quasselClient
    tor-browser

    eza

    scrcpy

    gapless
    
    stellarium
    ayugram-desktop
    #nix-search-cli
    #nix-search-tv
    obsidian
    #logseq
    dosbox-staging
    dosbox-x
    wineWow64Packages.stagingFull
    scummvm
    mgba
    openmsx
    qalculate-gtk
    btop
    fastfetch
    zig
    helix
    vscode

    onlyoffice-desktopeditors
    libreoffice-fresh

    diffuse
    git
    jujutsu
    sqlite
    far2l
    fossil
    mc
    fd
    uv
    #android-studio
    frankenphp
    deno
    bun
    go
    cmake
    autoconf
    automake
    gnumake
    xmake
    clang
    sfml
    sdl3

    goldendict-ng
    calibre
    foliate
    papers
    gnumeric
    abiword
    gnucash
    gnuchess
    #gnome-chess
    qtcreator
    qbittorrent
    tribler
    devenv
    blender
    gimp
    krita
    inkscape
    gajim
    tiled
    rclone
    restic
    ncdu
    strawberry
    ffmpeg-full
    i2pd
    i2pd-tools
    unrar
    libarchive
    showtime
    clifm
    tlp
    sqlitestudio
    binutils
    lldb
    android-tools

    thunderbird-esr
    aria2

    yt-dlp
    gallery-dl

    godot
    love
    luanti
    retroarch-free

    loupe
    vokoscreen-ng
    kdePackages.kdenlive
    shotcut
    #davinci-resolve
    steam-run

    #clojure
    #leiningen
    #scala
    luajitPackages.fennel
    lua
    luau

    manuskript
    kiwix
    kiwix-tools

    engrampa
    #llama-cpp
    #oils-for-unix
  ];

  networking.stevenblack.enable = true;

  virtualisation.docker.enable = true;
  programs.appimage.binfmt = true;

  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;
  nixpkgs.config.android_sdk.accept_license = true;

  programs.java.enable = true;
  programs.cdemu.enable = true;

  fonts.packages = (with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    corefonts
    adwaita-fonts
  ]) ++ (with pkgs.nerd-fonts;[
    hack
    tinos
    iosevka
    monofur
    zed-mono
    mononoki
    profont
    adwaita-mono
  ]);


  services.i2pd = {
    enable = true;

    /* ────────── Web-console ────────── */
    proto.http = {
      enable = true;     # usual one
      port   = 7070;
      # address is default (127.0.0.1)
    };

    /* ────────── Proxy ────────── */
    proto.httpProxy = {
      enable = true;
      port   = 4444;     # HTTP-proxy
    };

    proto.socksProxy = {
      enable = true;
      port   = 4447;     # SOCKS5-proxy
    };

    /* ────────── Subscriptions ────────── */
    addressbook.subscriptions = [
      "http://reg.i2p/hosts.txt"
      "http://notbob.i2p/hosts-all.txt"
      "http://identiguy.i2p/hosts.txt"
      "http://stats.i2p/cgi-bin/newhosts.txt"
      "http://i2p-projekt.i2p/hosts.txt"
    ];

    /* ────────── Client tunnels ────────── */
    outTunnels = {
      "IRC-ILITA" = {
        #type            = "client";
        address         = "127.0.0.1";
        port            = 6668;
        destination     = "irc.ilita.i2p";
        destinationPort = 6667;
        keys            = "irc-keys.dat";
        #"i2p.streaming.profile" = "2";
      };

      "IRC-IRC2P" = {
        #type            = "client";
        address         = "127.0.0.1";
        port            = 6669;
        destination     = "irc.postman.i2p";
        destinationPort = 6667;
        keys            = "irc2-keys.dat";
      };

      "SMTP" = {
        #type            = "client";
        address         = "127.0.0.1";
        port            = 7659;
        destination     = "smtp.postman.i2p";
        destinationPort = 25;
        keys            = "smtp-keys.dat";
      };

      "POP3" = {
        #type            = "client";
        address         = "127.0.0.1";
        port            = 7660;
        destination     = "pop.postman.i2p";
        destinationPort = 110;
        keys            = "pop3-keys.dat";
      };
    };
  };

  services.power-profiles-daemon.enable = false;

    # Enable TLP
  services.tlp = {
    enable = false;
    settings = {
      CPU_SCALING_MIN_FREQ_ON_AC = 1700000;
      CPU_SCALING_MAX_FREQ_ON_AC = 1700000;
      CPU_SCALING_MIN_FREQ_ON_BAT = 1700000;
      CPU_SCALING_MAX_FREQ_ON_BAT = 1700000;

      # disable bluetooth by default
      RESTORE_DEVICE_STATE_ON_STARTUP = 0;         # dont reset saved state
      DEVICES_TO_DISABLE_ON_STARTUP   = ""; # you may add "wifi wwan bluetooth"
    };
  };

  systemd.services.ryzenadj-setup = {
    enable = false;
    description = "Run ryzenadj once at boot";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
      #ExecStart = "${pkgs.ryzenadj}/bin/ryzenadj --tctl-temp=82 --power-saving";
      ExecStart = "${pkgs.ryzenadj}/bin/ryzenadj --tctl-temp=85";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
