{ config, pkgs, ... }:

let
  current-flake = pkgs.callPackage ../../packages/self-flake.nix {};
in
{
  config.system.extraSystemBuilderCmds = ''
      ln -s ${current-flake} $out/flake
  '';
}
