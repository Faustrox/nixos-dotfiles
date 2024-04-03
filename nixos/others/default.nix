{ lib, ... }:

{

  imports = [
    ./gaming.nix
    ./main-user.nix
    ./docker.nix
  ];

}
