# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# { config, pkgs, pkgs_i686, ... }:
{ config, pkgs, ... }:
{
  # allowing unfree packages :(
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./zsh.nix
      ./direnv.nix
      ./users/beren.nix
    ];


  # Use nvida non free packages
  hardware.nvidiaOptimus.disable = true;
  # hardware.opengl.extraPackages = [ pkgs.linuxPackages.nvidia_x11.out ];
  # hardware.opengl.extraPackages32 = [ pkgs.linuxPackages.nvidia_x11.lib32 ];
  # hardware.opengl.extraPackages32 = [ pkgs_i686.linuxPackages.nvidia_x11.out ];
  
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  hardware.bluetooth = {
    enable = true;
    settings = {
      Policy = {
        AutoEnable = false;
      };
    };
  };
 
  # Use the systemd-boot EFI boot loader.

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  networking = {
    hostName = "beleriand"; # Define your hostname.
    wireless.enable = true;
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {from = 1716; to = 1764;}
      ];
      allowedUDPPortRanges = [
        {from = 1716; to = 1764;}
      ];
    };
  }; 

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };
  console.keyMap = "us";
  # Set your time zone.
  time.timeZone = "Europe/Paris";

    # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; 
  # overriding a package
  [ 
    # basic utils
    wget
    git
    # DE
    nordic
    gnome3.gnome-tweaks
    gnomeExtensions.gsconnect
    neofetch

    htop
    mpv
    vlc
    ffmpeg
    handbrake
    youtube-dl
    zip
    unzip
    scrot
    neofetch
    ntfs3g
    ranger
    zathura
    bat
    niv

    # manage the home
    home-manager
    # web
    firefox-wayland
    chromium 
    transmission-gtk
    
    zsh
    
    # RStudio-with-my-packages
 
    # python stuff

    # VMs and containers
    docker
    # nixops # python2.7 CVE
    
    # security
    pass
 
    # misc
    gimp
    vlc
    libreoffice
    vscodium
    tdesktop
    calibre
    zoom-us
    skype 
    element-desktop

    # games
    # discord 
    steam
    steam-run
    dosbox
    wine
    lutris

    # dev
    pgmodeler
 

  ];


  # };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.vim.defaultEditor = true;
  programs.browserpass.enable = true;
  # List services that you want to enable:
  virtualisation.docker.enable = true;  
  virtualisation.virtualbox.host.enable = true;  
  users.extraGroups.vbxusers.members = [ "beren" ];
  # acpid
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 64738 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "compose:ralt";
    libinput.enable = true;
    videoDrivers = ["intel"];
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
  
  # to enable android phones
  services.udev.packages = [ pkgs.android-udev-rules ];
  programs.adb.enable = true;

  # to login with fingerprint
  # services.fprintd.enable = true;
  # security.polkit = {
  #  enable = true;
  #  extraConfig = ''
  #    polkit.addRule(function (action, subject) {
  #      if (action.id == "net.reactivated.fprint.device.enroll") {
  #        return subject.user == "root" ? polkit.Result.YES : polkit.result.NO
  #     }
  #  })
  #   '';
  # };

  fonts.fonts = with pkgs;[
    ubuntu_font_family
    fira-code
    powerline-fonts
    noto-fonts-emoji
    font-awesome-ttf
    hack-font
    siji
    unifont
    iosevka
  ];

  # power management
  services.power-profiles-daemon.enable = false;
  services.tlp = {
	enable = true;
	settings = {
        "TLP_ENABLE"=1;
        "TLP_DEFAULT_MODE"="BAT";
        "TLP_PERSISTENT_DEFAULT"=1;
        "DISK_IDLE_SECS_ON_AC"=0;
        "DISK_IDLE_SECS_ON_BAT"=2;
        "MAX_LOST_WORK_SECS_ON_AC"=15;
        "MAX_LOST_WORK_SECS_ON_BAT"=60;
        "CPU_SCALING_GOVERNOR_ON_AC"="powersave";
        "CPU_SCALING_GOVERNOR_ON_BAT"="powersave";
        "CPU_HWP_ON_AC"="default";
        "CPU_HWP_ON_BAT"="balance_power";
        "CPU_MAX_PERF_ON_AC"=100;
        "CPU_MIN_PERF_ON_BAT"=0;
        "CPU_MAX_PERF_ON_BAT"=100;
        "SCHED_POWERSAVE_ON_AC"=1;
        "SCHED_POWERSAVE_ON_BAT"=1;
        "NMI_WATCHDOG"=0;
        "ENERGY_PERF_POLICY_ON_AC"="default";
        "ENERGY_PERF_POLICY_ON_BAT"="balance-power";
        "DISK_DEVICES"="sda sdb";
        "DISK_APM_LEVEL_ON_AC"="254 254";
        "DISK_APM_LEVEL_ON_BAT"="128 128";
        "SATA_LINKPWR_ON_AC"="med_power_with_dipm max_performance";
        "SATA_LINKPWR_ON_BAT"="med_power_with_dipm min_power";
        "AHCI_RUNTIME_PM_TIMEOUT"=15;
        "PCIE_ASPM_ON_AC"="performance";
        "PCIE_ASPM_ON_BAT"="powersave";
        "RADEON_POWER_PROFILE_ON_AC"="high";
        "RADEON_POWER_PROFILE_ON_BAT"="low";
        "RADEON_DPM_STATE_ON_AC"="performance";
        "RADEON_DPM_STATE_ON_BAT"="battery";
        "RADEON_DPM_PERF_LEVEL_ON_AC"="auto";
        "RADEON_DPM_PERF_LEVEL_ON_BAT"="auto";
        "WIFI_PWR_ON_AC"="off";
        "WIFI_PWR_ON_BAT"="on";
        "SOUND_POWER_SAVE_ON_AC"=0;
        "SOUND_POWER_SAVE_ON_BAT"=0;
        "SOUND_POWER_SAVE_CONTROLLER"="Y";
        "BAY_POWEROFF_ON_AC"=0;
        "BAY_POWEROFF_ON_BAT"=0;
        "BAY_DEVICE"="sr0";
        "RUNTIME_PM_ON_AC"="on";
        "RUNTIME_PM_ON_BAT"="auto";
        "USB_AUTOSUSPEND"=1;
        "USB_BLACKLIST_BTUSB"=0;
        "USB_BLACKLIST_PHONE"=0;
        "USB_BLACKLIST_PRINTER"=1;
        "USB_BLACKLIST_WWAN"=1;
        "RESTORE_DEVICE_STATE_ON_STARTUP"=0;
    };
  };
  location = {
    latitude = 46.20;
    longitude = 6.14;
  };
  # redshift
  services.redshift = {
      enable = false;
      temperature = {
        day = 5500;
        night = 3500;
      };
      brightness = {
        day = "1.0";
        night = "0.7";
      };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

