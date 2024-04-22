{ lib, ... }:

{

  imports = [
    ./docker.nix
    ./gaming.nix
    ./ollama.nix
  ];

}
