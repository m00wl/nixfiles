{ config, pkgs, ... }:

{
  hardware.firmware = with pkgs; [
      raspberrypiWirelessFirmware
  ];

  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];
}
