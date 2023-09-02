{ pkgs, ... }:
{
  home.packages = with pkgs; [ coqPackages.coq ];
  programs.vim.plugins = with pkgs.vimPlugins; [ Coqtail ];
}
