{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sddm-catppuccin = {
      url = "github:khaneliman/sddm-catppuccin";
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
          { 
            nixpkgs.config.allowAliases = false;
            nixpkgs.overlays = [ 
              nur.overlay
              # Dynamic triple buffering Gnome
              (final: prev: {
                gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
                  mutter = gnomePrev.mutter.overrideAttrs ( old: {
                    src = nixpkgs.legacyPackages.x86_64-linux.fetchgit {
                      url = "https://gitlab.gnome.org/vanvugt/mutter.git";
                      # GNOME 45: triple-buffering-v4-45
                      rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
                      sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
                    };
                  } );
                });
              })
            ];
          }
        ];
      };
    };
  };
}
