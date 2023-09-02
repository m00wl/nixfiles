{
  programs.vim = {
    enable = true;
    defaultEditor = true;

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

      " map <F4> to toggle line markers
      highlight ColorColumn ctermbg=gray
      let s:linemarkers = 0
      fun! ToggleLineMarkers()
        if s:linemarkers == 0
          let s:linemarkers = 1
          set cc=81,101
          echo '  linemarkers'
        else
          let s:linemarkers = 0
          set cc=
          echo 'nolinemarkers'
        endif
      endfun

      nnoremap <F4> :call ToggleLineMarkers()<CR>
      imap <F4> <C-O><F4>

      " set listchars and map <F5> to toggle list mode
      nnoremap <F5> :set list! lcs=tab:>·,space:·,trail:!,precedes:<,extends:>,eol:$ list?<CR>
      imap <F5> <C-O><F5>
    '';
  };
}
