{pkgs, ...}:
 with import <nixpkgs> {};
let 
customPlugins = {
  completor = vimUtils.buildVimPlugin {
      name = "completor-git-2018-11-06";
      buildPhase = "true"; # building requires npm (for js) so I disabled it
      src = fetchgit {
        url = "https://github.com/maralla/completor.vim.git";
        rev = "9d1b13e8da098aeb561295ad6cf5c3c2f04e2183";
        sha256 = "0inng9a4532wgpq3scd80qvijfvs9glnpizk8agk68c69n4809lx";
        };
        meta = {
        homepage = https://github.com/maralla/completor.vim;
        maintainers = [ stdenv.lib.maintainers.jagajaga ];
        };
     };
  };
in
{
 programs.home-manager.enable = true;
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Louis KLEIN";
    userEmail = "louis.klein7@gmail.com";
  };

  programs.command-not-found.enable = true;

  programs.neovim = {
    enable = true;
    
configure = {
  customRC = ''
      filetype plugin indent on
      " configure maralla/completor to use tab
      " other configurations are possible (see website)
      inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
      inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
      " ultisnips default bindings compete with completor's tab
      " so we need to remap them
      let g:UltiSnipsExpandTrigger="<c-t>"
      let g:UltiSnipsJumpForwardTrigger="<c-b>"
      let g:UltiSnipsJumpBackwardTrigger="<c-z>"
      " airline :
      " for terminology you will need either to export TERM='xterm-256color'
      " or run it with '-2' option
      let g:airline_powerline_fonts = 1
      set laststatus=2
      au VimEnter * exec 'AirlineTheme hybrid'
      set encoding=utf-8
      if exists('+termguicolors') " true color with alacritty (https://github.com/jwilm/alacritty/issues/109)
        let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
        set termguicolors
      endif
      let g:gruvbox_italic=1
      let g:gruvbox_bold=1
      let g:gruvbox_contrast_dark='soft'
	  if &term =~ '256color'
	    " disable Background Color Erase (BCE) so that color schemes
	    " render properly when inside 256-color tmux and GNU screen.
	    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
	    set t_ut=
	  endif
      set background=dark
      syntax on
      colo gruvbox
      " set background=light
      " colo PaperColor
      set number
      let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
      " replace tabs
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set expandtab
      " highlight trailing whitespace
      highlight ExtraWhitespace ctermbg=red guibg=red
      match ExtraWhitespace /\s\+\%#\@<!$/
      " some more rust
      let g:LanguageClient_loadSettings = 1 " this enables you to have per-projects languageserver settings in .vim/settings.json
      let g:rustfmt_autosave = 1
      let g:rust_conceal = 1
      set hidden
      au BufEnter,BufNewFile,BufRead *.rs syntax match rustEquality "==\ze[^>]" conceal cchar=≟
      au BufEnter,BufNewFile,BufRead *.rs syntax match rustInequality "!=\ze[^>]" conceal cchar=≠
      " let's autoindent c files
      au BufWrite *.c call LanguageClient#textDocument_formatting()
      " run language server for python, rust and c
      let g:LanguageClient_autoStart = 1
      let g:LanguageClient_serverCommands = {
      \ 'python': ['pyls'],
      \ 'rust': ['rustup', 'run', 'stable', 'rls'],
      \ 'javascript': ['javascript-typescript-stdio'],
      \ 'go': ['go-langserver'],
      \ 'c' : ['clangd'] }
      nnoremap <F5> :call LanguageClient_contextMenu()<CR>
      nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR> " hit :pc to close the preview window
      nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
      set mouse=a
  '';
	vam.knownPlugins = pkgs.vimPlugins // customPlugins;
	vam.pluginDictionnaries = [
	  "idris-vim"
	  "vim-airline"
	  "The_NERD_tree" # file system explorer
	  "fugitive" "vim-gitgutter" # git 
          "vim-sensible"
          "vim-airline"
          "vim-airline-themes"
          "gruvbox"
          "vim-devicons"
          "webapi-vim"
          "vim-fugitive"
          "ultisnips"
          "vim-snippets"
          "LanguageClient-neovim"
          "rust-vim"
          "vim-nix"
          "completor"
	];
   };
  };
}
