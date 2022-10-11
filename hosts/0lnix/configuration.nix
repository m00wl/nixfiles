{ config, pkgs, lib, ... }:

{
  config = {
    nixpkgs.config.allowUnsupportedSystem = true;

    # Choose cross-compilation system
    # either from examples:
    #nixpkgs.crossSystem = lib.systems.examples.raspberryPi;
    # or specify directly:
    #nixpkgs.crossSystem = {
    #  config = "aarch64-unknown-linux-gnu";
    #  system = "aarch64-linux";
    #  #config = "x86_64-unknown-linux-gnu";
    #  #system = "x86_64-linux";
    #};

    # See https://github.com/NixOS/nixpkgs/issues/126755
    nixpkgs.overlays = [
      (final: super: {
        makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
      })
    ];

    # Enable distributed builds and register remote builder.
    #nix.distributedBuilds = true;
    #nix.buildMachines = [ {
    #  hostName = "remote.builder.machine";
    #  sshUser = "user";
    #  system = "x86_64-linux";
    #  # If the builder supports building for multiple architectures,
    #  # replace the previous line by, e.g.,
    #  #systems = [ "x86_64-linux" "aarch64-linux" ];
    #  maxJobs = 1;
    #  speedFactor = 2;
    #  supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    #  mandatoryFeatures = [ ];
    #}];

    time.timeZone = "Europe/Amsterdam";

    networking.hostName = "0lnix";

    environment.systemPackages = with pkgs; [
      vim
      wget
    ];

    system.stateVersion = "22.05";
  };

  # Import other modules from the collection in this repository.
  #imports = [
  #  ../../modules/src/rpi.nix
  #];
}
