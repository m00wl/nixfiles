{ config, pkgs, ...}:

{
  # Configure sops-nix
  # This expects secrets to be available at /etc/nixos/secrets
  sops = {
    defaultSopsFile = ../../hosts/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
