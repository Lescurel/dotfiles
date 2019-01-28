# Largely adapted from: https://www.mpscholten.de/nixos/2016/04/11/setting-up-vim-on-nixos.html
with import <nixpkgs> {};

let plugins = let inherit (vimUtils) buildVimPluginFrom2Nix; in {
  "better-whitespace" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "better-whitespace";
    src = fetchgit {
      url = "git://github.com/ntpeters/vim-better-whitespace";
      rev = "7729bada7ad8d341b910367da8a900490bd15e86";
      sha256 = "0kkj13jjzjyv2b17sk8bka2d55czz7v6xvv0zz1i8qidvg6lbniw";
    };
    dependencies = [];
  };
  "systemd-syntax" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "systemd-syntax";
    src = fetchgit {
      url = "git://github.com/Matt-Deacalion/vim-systemd-syntax";
      rev = "05bd51f87628e4b714b9d1d16259e1ead845924a";
      sha256 = "04jlbm4cf47kvys22czz1i3fcqzz4zih2h6pkcfns9s8rs6clm3c";
    };
    dependencies = [];
  };
  "opencl-syntax" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "opencl-syntax";
    src = fetchgit {
      url = "git://github.com/petRUShka/vim-opencl";
      rev = "a75693fdb1526cf0f2f2d1a6bdc23d6537ac1b6f";
      sha256 = "0ba3kj65h2lsn7s0fazhmbaa7nr8b9ssda3i54259mcc4nhwvi7b";
    };
    dependencies = [];
  };
}; in vim_configurable.customize {
    name = "vim";
    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins // plugins;
    vimrcConfig.vam.pluginDictionaries = [
      { names = [
        "Solarized"
        "better-whitespace"
        "elm-vim"
        "calendar-vim"
        "fugitive"
        "opencl-syntax"
        "surround"
        "systemd-syntax"
        "vim-nix"
        "vimtex"
        "vimwiki"
        #https://github.com/vim-voom/VOoM
        #https://github.com/tpope/vim-obsession
      ]; }
    ];
    vimrcConfig.customRC = ''
      " Must have for vim
      set nocompatible

      " Display nbsp
      set listchars=tab:\|\ ,nbsp:·
      set list

      " Remap ESC on ,,
      map ,, <ESC>
      imap ,, <ESC>

      scriptencoding utf-8

      " Must be *after* pathogen
      filetype plugin indent on

      " Leader
      let mapleader=","
      nnoremap <leader>a :echo("\<leader\> works! It is set to <leader>")<CR>
      " let maplocalleader = "-"

      " Highlighting
      syntax enable
      if has('gui_running')
          " When gui is running, it pretty much sets its own colors
          set background=light
          set guifont=Inconsolata\ 16
      else
          " If we're in a terminal, then we stay default, terminal will choose
          " which colors it likes.
          set background=dark
      endif

      let g:solarized_termcolors=16
      colorscheme solarized

      " Set line numbering
      set number

      " Don't wrap lines, it's ugly
      set nowrap

      " Deal with tabs
      set softtabstop=2
      set tabstop=2    " 1 tab = 2 spaces
      set shiftwidth=2 " Indent with 2 spaces
      set expandtab    " Insert spaces instead of tabs

      " Set par as default wrapper
      set formatprg=${par.outPath}/bin/par\ -w80

      " Set mouse on
      set mouse=a

      " Don't set timeout - this breaks the leader use
      set notimeout
      set ttimeout

      " Color lines in a different shade up to 80 columns
      let &colorcolumn=join(range(81,999),",")

      " automatically jump to the end of the text you just copied/pasted:
      xnoremap <silent> y y`]
      nnoremap <silent> yy yy`]
      xnoremap <silent> p p`]
      xnoremap <silent> P P`]
      nnoremap <silent> p p`]
      nnoremap <silent> P P`]

      " vimtex options
      let g:vimtex_fold_enabled=1
      let g:vimtex_fold_manual=1
      let g:vimtex_compiler_enabled=0

      " conceal to unicode symbols
      nnoremap <leader>l :silent let &conceallevel = (&conceallevel+1)%4<CR>
      set conceallevel=2
      set concealcursor=nvc
      let g:tex_conceal="abdmgs"

      " nice pluginless stuff
      set path+=**
      set wildmenu

      " Tag generation
      command! MakeTags !ctags -R .

      " Less noise in netrw
      let g:netrw_banner=0
      let g:netrw_browse_split=4
      let g:netrw_altv=1
      let g:netrw_liststyle=3
      let g:netrw_list_hide=netrw_gitignore#Hide()
      let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

      " Normal backspace
      set backspace=indent,eol,start

      " Set filetype tex for tikz files
      au BufNewFile,BufRead *.tikz set filetype=tex

      " vimwiki stuff
      let g:vimwiki_list = [
        \{'path': '~/vimwiki/personal.wiki'}
      \]
      au BufRead,BufNewFile *.wiki set filetype=vimwiki
      :autocmd FileType vimwiki map <leader>d :VimwikiMakeDiaryNote
      function! ToggleCalendar()
        execute ":Calendar"
        if exists("g:calendar_open")
          if g:calendar_open == 1
            execute "q"
            unlet g:calendar_open
          else
            g:calendar_open = 1
          end
        else
          let g:calendar_open = 1
        end
      endfunction
      :autocmd FileType vimwiki map <leader>c :call ToggleCalendar()

    '';
}

