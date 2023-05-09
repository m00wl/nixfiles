{ pkgs, ... }:

{
  home.packages = with pkgs; [ coq ];
  programs.vim.plugins = with pkgs.vimPlugins; [ Coqtail ];
}
