{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      url = "git+https://github.com/Noodlez1232/suyu-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs: let
    system = "x86_64-linux";

    originPkgs = inputs.nixpkgs.legacyPackages.${system};
    pkgsPatches = [
      
      { meta.description = "gpu-screen-recorder{-,gtk} 4.2.1 -> 4.2.3";
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/349665.diff";
        sha256 = "BWmU1qzU1EtbT4i5Eqj3UmB9L/pF98rz/RyQIRiykHA=";
      }

    ];
    patchedNixpkgs = originPkgs.applyPatches {
      name = "nixpkgs-patched";
      src = inputs.nixpkgs;
      patches = map originPkgs.fetchpatch pkgsPatches;
    };

    nixosSystem = import (patchedNixpkgs + "/nixos/lib/eval-config.nix");
  in {
    nixosConfigurations = {
      the-hope = nixosSystem {
        inherit system;

        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/the-hope/configuration.nix
          ./nixos
          inputs.home-manager.nixosModules.home-manager
          inputs.lix-module.nixosModules.default
          inputs.chaotic.nixosModules.default
          inputs.catppuccin.nixosModules.catppuccin
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
                    inputs.hyprland.homeManagerModules.default
                    inputs.chaotic.homeManagerModules.default
                    inputs.catppuccin.homeManagerModules.catppuccin
                    inputs.spicetify-nix.homeManagerModules.default
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
