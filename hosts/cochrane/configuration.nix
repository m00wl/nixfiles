{ config, pkgs, lib, modulesPath, ... }:

let
  key = ../../users/m00wl/id_ed25519_mwl.pub;
in {
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
  boot.kernelParams = [ "console=ttyS0,115200" ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  networking.hostName = "cochrane";
  systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keyFiles = [ key ];
}
