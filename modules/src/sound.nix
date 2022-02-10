{ config, pkgs, ... }:

{
  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
