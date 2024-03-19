{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      the-hope = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/the-hope/configuration.nix
          home-manager.nixosModules.home-manager 
          {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.faustrox = import ./hosts/the-hope/home.nix;
          }
        ];
      };
    };
  };
}