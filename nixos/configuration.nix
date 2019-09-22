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
      ./rice.nix 
      ./zsh.nix
      ./direnv.nix
    ];


  # Use nvida non free packages
  hardware.nvidiaOptimus.disable = true;
  hardware.opengl.extraPackages = [ pkgs.linuxPackages.nvidia_x11.out ];
  hardware.opengl.extraPackages32 = [ pkgs.linuxPackages.nvidia_x11.lib32 ];
  # hardware.opengl.extraPackages32 = [ pkgs_i686.linuxPackages.nvidia_x11.out ];
  
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
 
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "beleriand"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

    # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; 
  # overriding a package
  let 
    RStudio-with-my-packages = rstudioWrapper.override{ packages = with rPackages; [ ggplot2 dplyr xts ]; };
  in [
    # hardware stuff
    libfprint
    # basic utils
    wget
    vim
    # (import ./vim/my_vim.nix { inherit vim_configurable vimUtils vimPlugins stdenv fetchgit;})
    #(import ./vim/another_vim.nix)
    git
    # DE
    nordic-polar
    bspwm
    sxhkd
    xorg.xbacklight
    rofi
    rxvt_unicode
    kitty
    polybar
    neofetch
    feh
    htop
    mpv
    arandr
    zip
    unzip
    scrot
    neofetch
    udiskie ntfs3g
    ranger
    zathura
    bat

    # manage the home
    home-manager
    # web
    firefox
    transmission-gtk
    
    zsh
    
    # RStudio-with-my-packages
 
    # python stuff
    conda
    pypi2nix
    # (python36.withPackages(ps: with ps; [ numpy toolz tensorflow Keras tensorflow-tensorboard]))

    # VMs and containers
    docker
    nixops
    
    # security
    pass
 
    # misc
    gimp
    vlc
    libreoffice
    vscode
    tdesktop

    # games
    # steam
    wine
    lutris
 
    # Computing
    # cudatoolkit
    #  cudnn
    texlive.combined.scheme-full
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.vim.defaultEditor = true;
  programs.browserpass.enable = true;
  hardware.brightnessctl.enable = true;
  # List services that you want to enable:
  virtualisation.docker.enable = true;  
  # virtualisation.virtualbox.host.enable = true;  
  # users.extraGroups.vbxusers.members = [ "beren" ];
  # acpid
  services.acpid = {
    enable = true;
    lidEventCommands = ''
      export LID_STATE=$(awk '{print$NF}' /proc/acpi/button/lid/LID0/state)
      if [[ $LID_TATE == "closed" ]]; then
        ${pkgs.lightdm}/bin/dm-tool lock
      fi
    '';
  };
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "compose:ralt";
  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # We try to fix the tearing
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.deviceSection = ''
    Option "DRI" "2"
    Option "TearFree" "true"
  '';
  
  # power management
  services.tlp = {
	enable = true;
	extraConfig = ''
      TLP_ENABLE=1
      TLP_DEFAULT_MODE=BAT
      TLP_PERSISTENT_DEFAULT=1
      DISK_IDLE_SECS_ON_AC=0
      DISK_IDLE_SECS_ON_BAT=2
      MAX_LOST_WORK_SECS_ON_AC=15
      MAX_LOST_WORK_SECS_ON_BAT=60
      CPU_SCALING_GOVERNOR_ON_AC=powersave
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
      CPU_HWP_ON_AC=default
      CPU_HWP_ON_BAT=balance_power
      CPU_MAX_PERF_ON_AC=100
      CPU_MIN_PERF_ON_BAT=0
      CPU_MAX_PERF_ON_BAT=100
      SCHED_POWERSAVE_ON_AC=1
      SCHED_POWERSAVE_ON_BAT=1
      NMI_WATCHDOG=0
      ENERGY_PERF_POLICY_ON_AC=default
      ENERGY_PERF_POLICY_ON_BAT=balance-power
      DISK_DEVICES="sda sdb"
      DISK_APM_LEVEL_ON_AC="254 254"
      DISK_APM_LEVEL_ON_BAT="128 128"
      SATA_LINKPWR_ON_AC="med_power_with_dipm max_performance"
      SATA_LINKPWR_ON_BAT="med_power_with_dipm min_power"
      AHCI_RUNTIME_PM_TIMEOUT=15
      PCIE_ASPM_ON_AC=performance
      PCIE_ASPM_ON_BAT=powersave
      RADEON_POWER_PROFILE_ON_AC=high
      RADEON_POWER_PROFILE_ON_BAT=low
      RADEON_DPM_STATE_ON_AC=performance
      RADEON_DPM_STATE_ON_BAT=battery
      RADEON_DPM_PERF_LEVEL_ON_AC=auto
      RADEON_DPM_PERF_LEVEL_ON_BAT=auto
      WIFI_PWR_ON_AC=off
      WIFI_PWR_ON_BAT=on
      SOUND_POWER_SAVE_ON_AC=0
      SOUND_POWER_SAVE_ON_BAT=0
      SOUND_POWER_SAVE_CONTROLLER=Y
      BAY_POWEROFF_ON_AC=0
      BAY_POWEROFF_ON_BAT=0
      BAY_DEVICE="sr0"
      RUNTIME_PM_ON_AC=on
      RUNTIME_PM_ON_BAT=auto
      USB_AUTOSUSPEND=1
      USB_BLACKLIST_BTUSB=0
      USB_BLACKLIST_PHONE=0
      USB_BLACKLIST_PRINTER=1
      USB_BLACKLIST_WWAN=1
      RESTORE_DEVICE_STATE_ON_STARTUP=0
      DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE="bluetooth"
    '';
  };
  location = {
    latitude = 59.43;
    longitude = 17.83;
  };
  # redshift
  services.redshift = {
      enable = true;
      temperature = {
        day = 5500;
        night = 3500;
      };
      brightness = {
        day = "1.0";
        night = "0.7";
      };
  };
  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  #services.xserver.desktopManager = {
  #  default = "none";
  #  xterm.enable = false;
  #};
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.beren = {
    isNormalUser = true;
    home = "/home/beren";
    shell = pkgs.zsh;
    description = "Beren";
    extraGroups = [ "wheel" "audio" "video" "docker" "beren"];
    initialPassword = "test";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

