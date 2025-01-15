# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# { config, pkgs, pkgs_i686, ... }:
{ config, pkgs, ... }:
{
  # allowing unfree packages :(
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      fcitx-engines = pkgs.fcitx5;
    })
  ];
  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.bluetooth = {
    enable = true;
    settings = {
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  networking = {
    wireless.iwd.enable = true;
    # Open ports in the firewall.
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8080 22];
      allowedTCPPortRanges = [
        {from = 1716; to = 1764;}
        {from = 20000; to = 65000;}
      ];
      allowedUDPPortRanges = [
        {from = 1716; to = 1764;}
        {from = 5656; to = 5699;} # Unifi
      ];
      allowedUDPPorts = [ 1900 10001 3478];
      extraPackages = [ pkgs.conntrack-tools ];
      autoLoadConntrackHelpers = false;
      extraCommands = ''
        nfct add helper ssdp inet udp
        iptables --verbose -I OUTPUT -t raw -p udp --dport 1900 -j CT --helper ssdp
      '';
    };
  };

  # unifi for AP
  # services.unifi.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };
  console.keyMap = "us";
  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

    # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
  # overriding a package
  let
    mySteam = steam.override {
      extraPkgs = pkgs: with pkgs; [libpng];
    };
  in
  [
    # basic utils
    wget
    git
    # DE
    nordic
    gnome-tweaks
    gnomeExtensions.gsconnect
    neofetch

    htop
    mpv
    vlc
    ffmpeg
    handbrake
    yt-dlp
    zip
    unzip
    scrot
    neofetch
    ntfs3g
    ranger
    bat
    niv
    silver-searcher
    zsh

    # manage the home
    home-manager

    # web
    firefox
    chromium
    transmission_4-gtk

    # VMs and containers
    docker

    # password manager
    pass
    wl-clipboard
    tomb

    # misc
    gimp
    vlc
    libreoffice
    tdesktop
    calibre
    zoom-us
    skypeforlinux
    element-desktop

    # Making CAD/CAM
    # cura #libarcus is broekn atm
    openscad
    blender

    # games
    discord
    mySteam
    steam-run
    dosbox
    wine
    lutris
    openmw

    # dev
    emacs

    # audio
    lmms
    ardour
    musescore
  ];

  # };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
  programs.browserpass.enable = true;
  programs.firefox.nativeMessagingHosts.packages = ["browserpass"];

  # List services that you want to enable:
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vbxusers.members = [ "beren" ];
  # acpid
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  # TRIM for SSD
  services.fstrim.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Enable sound.
  # We use pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb = {
      options = "compose:ralt";
      layout = "us";
    };
    deviceSection = ''
      Option "DRI" "2"
      Option "TearFree" "true"
    '';
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
  };
  services.libinput.enable = true;

  # to enable android phones
  services.udev.packages = [ pkgs.android-udev-rules ];
  programs.adb.enable = true;

  # gnome extensions
  services.gnome.gnome-settings-daemon.enable = true;

  fonts.packages = with pkgs;[
    ubuntu_font_family
    fira-code
    powerline-fonts
    noto-fonts-emoji
    font-awesome
    hack-font
    siji
    unifont
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "24.11"; # Did you read the comment?

}
