{pkgs,...}:
let colors = import ./colors.nix; in
let
  udiskie-helper = import ./udiskie-rofi.nix {
    inherit pkgs;
  };
in 
with colors;
{
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Lescurel";
    userEmail = "louis.klein7@gmail.com";
  };

  programs.command-not-found.enable = true;

  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile vim/vimrc;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      sensible
      vim-airline
      The_NERD_tree # file system explorer
      fugitive
      vim-gitgutter # git
      rust-vim
      python-mode
      vim-nix
    ];
    extraPython3Packages = (ps: with ps; [ python-language-server setuptools ]);
  };

  xsession.windowManager.bspwm = {
    enable = true;
    monitors = {
      "eDP1" = [ "1" "2" "3" "4" "5" "6" ];
    };

    settings = {
      "border_width" = 4;
      "window_gap" = 10;
      "split_ratio" = 0.5;
      "borderless_monocle" = true;
      "gapless_monocle" = true;
      "initial_polarity" = "second_child";
      "focus_follows_pointer" = true;
      "focused_border_color" = "${blue}";
      "normal_border_color"  = "${dblue}";
      "presel_feedback_color"  = "${blue}";
      "urgent_border_color" = "${red}";
    };
  };

  services.sxhkd = {
    enable = true;
    keybindings = {
      "super + Return" = "${pkgs.kitty}/bin/kitty";
      "super + r " = "bspc node @/ -R 90";
      "super + x" = "dm-tool lock";
      "super + @space" = "${pkgs.rofi}/bin/rofi -modi run,drun,window -lines 12 -padding 18 -width 60 -location 0 -show drun -sidebar-mode -columns 2 ";
      "super + w" = "${pkgs.rofi}/bin/rofi -show windowcd";
      "super + d"  = "${udiskie-helper}";
      "super + p " = "sh ~/.config/polybar/start.sh";
      "super + Escape" = "pkill -USR1 -x sxhkd";
      "super + alt + Escape" = "bspc quit";
      "super + {_,shift + }q" = "bspc node -{c,k}";
      "super + m" = "bspc desktop -l next";
      "super + y" = "bspc query -N -n focused.automatic && bspc node -n last.!automatic || bspc node last.leaf -n focused";
      "super + g" = "bspc node -s biggest";
      "super + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
      "super + ctrl + {x,y,z}" = "bspc node -g {locked,sticky,private}";
      "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
      "super + {p,b,comma,period}" = "bspc node -f @{parent,brother,first,second}";
      "super + {_,shift + }c" = "bspc node -f {next,prev}.local";
      "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";
      "alt + {grave,Tab}" = "bspc {node,desktop} -f last";
      "super + {o,i}" = "bspc wm -h off;	bspc node {older,newer} -f; bspc wm -h on";
      "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
      "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
      "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";
      "super + ctrl + space" = "bspc node -p cancel";
      "super + ctrl + shift + space" = "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";
      "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
      "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
      "XF86AudioRaiseVolume" = "amixer set Master 1%+";
      "XF86AudioLowerVolume" = "amixer set Master 1%-";
      "XF86AudioMute" = "amixer -D pulse set Master 1+ toggle ";
      "XF86MonBrightnessUp" = "${pkgs.light}/bin/light -A 5";
      "XF86MonBrightnessDown" = "${pkgs.light}/bin/light -U 5";
      "super + Tab " = "bspc node -f next .local";
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        geometry = "300x5-19+60";
        indicate_hidden = "yes";
        shrink = "no";
        transparency = 10;
        notification_height = 0;
        padding = 8;
        horizontal_padding = 8;
        frame_color = "${blue}";
        separator_color = "frame";
        idle_threshold = 120;
        font = "Hack 9";
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = "yes";
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        max_icon_size = 32;
        icon_position = "left";
        sticky_history = "yes";
        history_length = 20;
        browser = "${pkgs.firefox}/bin/firefox -new-tab";
        title = "Dunst";
        class = "Dunst";
        startup_notification = false;
      };
      shortcuts = {
        close = "shift+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };
      urgency_low = {
        background = "${dark}";
        foreground = "${light}";
        timeout = 10;
      };
      urgency_normal = {
        background = "${dark}";
        foreground = "${accent}";
        timeout = 10;
      };
      urgency_critical = {
        background = "${dark}";
        foreground = "${accent}";
        frame_color = "${dred}";
        timeout = 0;
      };
    };
  };

  services.compton = {
    enable = true;
    fade = true;
    opacityRule = [
          "90:class_g = 'kitty' && !_NET_WM_STATE@:32a"
          "50:class_g = 'Bspwm' && class_i = 'presel_feedback'"
        ];
  };

  programs.zathura = {
    enable = true;
    options = {
      # zathurarc-dark
      notification-error-bg = "${dark}"; # base01  # seem not work
      notification-error-fg = "${red}"; # red
      notification-warning-bg = "${dark}"; # base01
      notification-warning-fg = "${red}"; # red
      notification-bg = "${dark}"; # base01
      notification-fg = "${yellow}"; # yellow
      completion-group-bg = "${mdark2}"; # base03
      completion-group-fg = "${accent}"; # base0
      completion-bg = "${dark}"; # base02
      completion-fg = "${light}"; # base1
      completion-highlight-bg = "${dark}"; # base01
      completion-highlight-fg = "${mlight}"; # base2
      index-bg = "${dark}"; # base02
      index-fg = "${light}"; # base1
      index-active-bg = "${dark}"; # base01
      index-active-fg = "${accent}"; # base2
      inputbar-bg = "${dark}"; # base01
      inputbar-fg = "${accent}"; # base2
      statusbar-bg = "${dark}"; # base02
      statusbar-fg = "${light}"; # base1
      highlight-color = "${green}"; # base00  # hightlight match when search keyword(vim's /)
      highlight-active-color = "${blue}"; # blue
      default-bg = "${dark}"; # base02
      default-fg = "${light}"; # base1
      recolor = true;
      recolor-lightcolor = "${dark}"; # base02
      recolor-darkcolor = "${light}"; # base1
    };
  };

  programs.password-store.enable = true;
  services.password-store-sync.enable = true;
  services.udiskie.enable = true;
  services.lorri.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      package = "${pkgs.fira-code}";
      name = "Fira Code 12";
    };
    keybindings = {
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+s" = "paste_from_selection";
      "ctrl+shift+c" = "copy_to_clipboard";
    };
    settings = {
      italic_font = "auto";
      bold_font = "auto";
      bold_italic_font = "auto";
      font_size = "12.0";
      font_size_delta = "2";
      foreground = "${light}";
      background = "${dark}";
      selection_foreground = "${accent}";
      selection_background = "${mdark}";
      cursor = "${accent}";
      cursor_opacity = "0.7";
      cursor_shape = "block";
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = "15.0";
      scrollback_lines = "2000";
      scrollback_pager = "less";
      scrollback_in_new_tab = "no";
      wheel_scroll_multiplier = "5.0";
      click_interval = "0.5";
      mouse_hide_wait = "3.0";
      enabled_layouts = "*";
      remember_window_size = "yes";
      initial_window_width = "640";
      initial_window_height = "400";
      repaint_delay = "10";
      visual_bell_duration = "0.0";
      enable_audio_bell = "yes";
      open_url_modifiers = "ctrl+shift";
      open_url_with = "default";
      use_system_wcwidth = "yes";
      term = "xterm-kitty";
      window_border_width = "1";
      window_margin_width = "0";
      window_padding_width = "0";
      color0 = "${dark}";
      color8 = "${mdark3}";
      color1 = "${red}";
      color9 = "${dred}";
      color2 = "${green}";
      color10 = "${dgreen}";
      color3 = "${yellow}";
      color11 = "${dyellow}";
      color4 = "${blue}";
      color12 = "${dblue}";
      color5 = "${magenta}";
      color13 = "${dmagenta}";
      color6 = "${cyan}";
      color14 = "${dcyan}";
      color7 = "${light}";
      color15 = "${mlight}";
    };

  };

}

