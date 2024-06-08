{ lib, ... }:

{
  imports = [
    ./bluetooth.nix
    ./sound.nix
    ./video.nix
  ];

  nvidia.open = lib.mkDefault false;

}