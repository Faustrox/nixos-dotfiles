{ lib, ... }:

{

  imports = [
    ./desktop
    ./others
    ./programs

    ./overlays.nix
  ];

}
