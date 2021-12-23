{ pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.vim = {
    enable = true;

    settings = {
      modeline = false;
      number = true;
      mouse = "a";
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      ignorecase = true;
      smartcase = true;
    };

    extraConfig = ''
      " return to last edit position when opening files
      autocmd BufReadPost *
          \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
          \ |   exe "normal! g`\""
          \ | endif

      " map <F2> to toggle line numbers
      nnoremap <F2> :set number! number?<CR>
      imap <F2> <C-O><F2>

      " map <F3> to toggle line soft wrap
      nnoremap <F3> :set wrap! wrap?<CR>
      imap <F3> <C-O><F3>


      " map <F4> to toggle overlines
      let s:overlines = 0
      fun! Toggle_overlines()
        if s:overlines == 0
          let s:overlines = 1
          match ErrorMsg '\%>80v.\+'
          echo "  overlines"
        else
          let s:overlines = 0
          match none
          echo "nooverlines"
        endif
      endfun

      nnoremap <F4> :call Toggle_overlines()<CR>
      imap <F4> <C-O><F4>

      " set listchars, showbreak,
      " and map <F5> to toggle list mode
      set listchars=tab:>·,space:·,trail:!,precedes:<,extends:>,eol:$
      "let &showbreak = '> '
      nnoremap <F5> :set list! list?<CR>
      imap <F5> <C-O><F5>
    '';
  };
}
