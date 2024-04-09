{ lib, ... }:

{
  imports = [
    ./bluetooth.nix
    ./sound.nix
    ./video.nix
  ];

  bluetooth.enable = lib.mkDefault true;
  sound.setup = lib.mkDefault true;

  nvidia.enable = lib.mkDefault true;
  nvidia.open = lib.mkDefault false;

}