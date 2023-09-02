{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "self-flake";
  src = ../.;
  installPhase = ''
    cp -r . $out/
  '';
}
