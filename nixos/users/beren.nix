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
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "docker"
      "beren"
      "adbusers"
      "plugdev"
      "input"
      "network"
      "networkmanager"
      "vbxusers"
    ];
    initialPassword = "test";
  };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.beren = {
    home.stateVersion = "24.05";
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
        # python-mode
        vim-nix
      ];
      # extraPython3Packages = (ps: with ps; [ python-language-server setuptools ]);
    };

    programs.alacritty.enable=true;

    services.lorri.enable = true;
  };
}
