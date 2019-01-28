# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs_i686, ... }:
{
  # allowing unfree packages :(
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./rice.nix 
      ./zsh.nix
    ];


  # Use nvida non free packages
  hardware.nvidiaOptimus.disable = true;
  hardware.opengl.extraPackages = [ pkgs.linuxPackages.nvidia_x11.out ];
  hardware.opengl.extraPackages32 = [ pkgs_i686.linuxPackages.nvidia_x11.out ];
  
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
  let miraclecastNoUdev = pkgs.miraclecast.overrideAttrs ( oldAttrs : rec { 
			mesonFlags = [ 
				"-Drely-udev=false" 
				"-Dbuild-tests=true" 
				     ]; 
				}
			);
 in [
    # hardware stuff
    libfprint
    # basic utils
    wget
    (import ./vim/my_vim.nix { inherit vim_configurable vimUtils vimPlugins stdenv fetchgit;})
    #(import ./vim/another_vim.nix)
    git
    # DE
    bspwm
    sxhkd
    rofi
    rxvt_unicode
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

    # manage the home
    home-manager
    # web
    firefox
    transmission-gtk
    zsh
    miraclecastNoUdev

 
    # python stuff
    conda
    (python36.withPackages(ps: with ps; [ numpy toolz tensorflowWithCuda Keras tensorflow-tensorboard]))

    # security
    pass
 
    # misc
    gimp
    vlc
    vscode
    # games
    steam
 
    # Computing
    cudatoolkit
    cudnn
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.vim.defaultEditor = true;
  programs.browserpass.enable = true;
  programs.light.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "compose:ralt";
  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  # power management
  services.tlp = {
	enable = true;
	extraConfig = ''
		      SOUND_POWER_SAVE_ON_AC=0
		      SOUND_POWER_SAVE_ON_BAT=0
                      '';
  };
  # redshift
  services.redshift = {
      enable = true;
      latitude = "46";
      longitude = "6";
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
    extraGroups = [ "wheel" "audio" "video" "beren"];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
