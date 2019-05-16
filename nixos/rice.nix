{pkgs, config, ...}:

with import ./configuration.nix;
let

  # urxvt = import ./urxvt/urxvt.nix { inherit pkgs; }; 
  kitty = import ./kitty/kitty.nix {inherit pkgs; };
  rofi = import ./rofi/rofi.nix { inherit pkgs; terminal = kitty; };
  polybar = import ./polybar/polybar.nix { inherit pkgs; };
  dunst = import ./dunst/dunst.nix { inherit pkgs; };
  wallpaper = pkgs.copyPathToStore ./art/wallpaper-1920-1080.jpg;  
  wallpaper-blurred = pkgs.copyPathToStore ./art/wallpaper-blurred.jpg;
  bspwm-config = 
    import ./bspwm/bspwmrc.nix {
      inherit pkgs; bar = polybar; notification = dunst; wallpaper = wallpaper; 
    };

  bspwm-config-file = 
    pkgs.writeTextFile {
	name = "nixos-bspwmrc";
        executable = true;
        text = bspwm-config;
    };

  sxhkd-config = 
    import ./sxhkd/sxhkd.nix {
      terminal = kitty;
      inherit pkgs rofi;
    };

  sxhkd-config-file = 
    pkgs.writeTextFile {
	name = "nixos-sxhkdrc";
        text = sxhkd-config;
    };

  gtk2-theme = import ./paper-gtk2-theme.nix pkgs;
  colors = import ./colors.nix;
in
with colors; {

  imports = [ 
    gtk2-theme
  ];
  
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

  # Desktop environment
  services = {
    compton = {
      enable = true;
      fade = true;
      opacityRules = [ "90:class_g = 'kitty' && !_NET_WM_STATE@:32a" ];
    };
    xserver = {
      serverFlagsSection = ''
          Option "BlankTime" "0"	      
        '';

      desktopManager = {
       default = "none";
       xterm.enable = false;
      }; 
     
     # Setting up the display manager
      displayManager.lightdm = {
        enable = true;
        background = wallpaper-blurred;
        # autoLogin.enable = true;
        # autoLogin.user = "beren";
        greeters.mini = {
        enable = true;
        user = "beren";
           extraConfig = ''
               [greeter]
               show-password-label = false
        [greeter-theme]
               font = Ubuntu Mono
               border-width = 0px
               border-color = "${blue}"
               window-color = "${dark}"
        layout-space = 0
        password-color = "${light}"
        password-background-color = "${dark}"
               
           '';
        };  
      };

      # Setup bspwm
      windowManager.bspwm = {
        enable = true;
	configFile = bspwm-config-file;
 	# configFile = null;
	sxhkd = {
          configFile = sxhkd-config-file;
	};
      };
    };
  };

  #TODO: remove these
  #services.xserver.displayManager.lightdm.autoLogin = {
  #	user = beren;
  #      enable = true;
  #};

  services.xserver.windowManager.default = "bspwm";

  environment.systemPackages = [ pkgs.dunst pkgs.ubuntu_font_family ];
}

