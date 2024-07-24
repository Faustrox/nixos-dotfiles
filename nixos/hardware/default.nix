{ lib, ... }:

{
  imports = [
    ./bluetooth.nix
    ./sound.nix
    ./video.nix
  ];

}