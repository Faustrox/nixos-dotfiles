{ lib, pkgs, ... }:

{
  imports = [
    ./bluetooth.nix
    ./nvidia.nix
    ./sound.nix
  ];

  hardware.firmware = with pkgs; [ linux-firmware ];

}