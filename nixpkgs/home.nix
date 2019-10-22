{pkgs,...}:
{
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Name";
    userEmail = "mail";
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
    ];
    extraPython3Packages = (ps: with ps; [ python-language-server setuptools ]);
  };

}

