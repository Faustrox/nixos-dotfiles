{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
    suyu-emu.url = "github:Noodlez1232/suyu-flake";
    nur.url = "github:nix-community/NUR";
    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs = { self, nixpkgs, home-manager, nur, catppuccin, ... }@inputs:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      the-hope = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/the-hope/configuration.nix
          ./nixos
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager 
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users = {
                faustrox = {
                  imports = [
                    ./hosts/the-hope/home.nix
                    ./home-manager
                    catppuccin.homeManagerModules.catppuccin
                  ];
                };
              };
            };
          }
          { nixpkgs.overlays = [ nur.overlay ]; }
        ];
      };
    };
  };
}
