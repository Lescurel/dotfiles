{pkgs,...}:
let 
  colors = import ../colors.nix; 
  # personal info
  # Should be a nix file with the following structure
  # {
  #   gitName = "Name";
  # }
  # with the required fields used in the current file
  # This file is NOT commited
  berenInfo = import ./beren_personal_info.nix;
in
with colors;
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.beren = {
    isNormalUser = true;
    home = "/home/beren";
    shell = pkgs.zsh;
    description = "Beren";
    extraGroups = [ "wheel" "audio" "video" "docker" "beren" "adbusers" "plugdev" "input"];
    initialPassword = "test";
  };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.beren = {
    programs.git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      userName = "${berenInfo.gitName}";
      userEmail = "${berenInfo.gitEmail}";
      signing.key = "${berenInfo.gitSigningKey}";
      delta.enable = true;
      
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
        The_NERD_tree # file system explorer:
        fugitive
        vim-gitgutter # git
        rust-vim
        python-mode
        vim-nix
      ];
      extraPython3Packages = (ps: with ps; [ python-language-server setuptools ]);
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

    services.lorri.enable = true;
  };
}

