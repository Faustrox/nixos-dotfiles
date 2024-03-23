{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    suyu-emu.url = "github:Noodlez1232/suyu-flake";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      the-hope = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/the-hope/configuration.nix
          home-manager.nixosModules.home-manager 
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users = {
                faustrox = import ./hosts/the-hope/home.nix;
              };
            };
          }
        ];
      };
    };
  };
}