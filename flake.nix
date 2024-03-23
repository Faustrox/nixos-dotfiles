{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    catppuccin.url = "github:catppuccin/nix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };

    umu = {
      url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    suyu = {
      url = "git+https://git.suyu.dev/suyu/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, catppuccin, spicetify-nix, hyprland, chaotic, ... }@inputs:
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
          chaotic.nixosModules.default
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs; };
              users = {
                faustrox = {
                  imports = [
                    ./hosts/the-hope/home.nix
                    ./home
                    catppuccin.homeManagerModules.catppuccin
                    hyprland.homeManagerModules.default
                    spicetify-nix.homeManagerModules.default
                    chaotic.homeManagerModules.default
                  ];
                };
              };
            };
          }
        ];
      };
    };
  };
}
