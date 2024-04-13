{ lib, ... }:

{

  imports = [
    ./docker.nix
    ./gaming.nix
    ./main-user.nix
    ./portals.nix
    ./ollama.nix
  ];

}
