{ lib, ... }:

{
  imports = [
    ./bluetooth.nix
    ./nvidia.nix
    ./sound.nix
  ];

}