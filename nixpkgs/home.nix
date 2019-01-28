{pkgs, ...}:
{
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Name";
    userEmail = "mail";
  };

  programs.command-not-found.enable = true;

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile vim/vimrc;
    settings = {
       number = true;
    };
    plugins = [
      "idris-vim"
      "sensible"
      "vim-airline"
      "The_NERD_tree" # file system explorer
      "fugitive" "vim-gitgutter" # git
      "rust-vim"
    ];
  };

}

