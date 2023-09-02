{ self, config, pkgs, ... }:
let
  current-flake = pkgs.callPackage self.packages.self-flake {};
in
{
  config.system.extraSystemBuilderCmds = ''
      ln -s ${current-flake} $out/flake
  '';
}
