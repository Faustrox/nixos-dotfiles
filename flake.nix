{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
    hyprland.url = "github:hyprwm/Hyprland";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    catppuccin.url = "github:catppuccin/nix";
    stylix.url = "github:danth/stylix";
    ags.url = "github:Aylur/ags";
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    nixcord.url = "github:kaylorben/nixcord";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs, ... }@inputs: let
    system = "x86_64-linux";

    originPkgs = inputs.nixpkgs.legacyPackages.${system};
    pkgsPatches = [
      {
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/374771.patch";
        sha256 = "KR0VznIRIPFmebz2YD6ycUItB6jDQJy3s738/mMkRuU=";  
      }
      # {
      #   url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/388171.diff";
      #   sha256 = "sha256-t8Sdg9JcBMac8Nqjbxvt/Q+0ZYW10bfgfvvIM8gEL4s=";  
      # }
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

        specialArgs = { 
          inherit inputs system;
        };

        modules = [
          ./hosts/the-hope/configuration.nix
          ./nixos
          ./overlays.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.chaotic.nixosModules.default
          inputs.lix-module.nixosModules.default
          inputs.catppuccin.nixosModules.catppuccin
          inputs.spicetify-nix.nixosModules.default
          inputs.disko.nixosModules.disko
          inputs.stylix.nixosModules.stylix
          {
            home-manager = {
              users.faustrox = import ./hosts/the-hope/home.nix;

              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-bkp";
              extraSpecialArgs = { inherit inputs; };
              sharedModules = [
                ./home
                inputs.chaotic.homeManagerModules.default
                inputs.hyprland.homeManagerModules.default
                inputs.catppuccin.homeManagerModules.catppuccin
                inputs.spicetify-nix.homeManagerModules.default
                inputs.ags.homeManagerModules.default
                inputs.nvf.homeManagerModules.default
                inputs.nixcord.homeManagerModules.nixcord
              ];
            };
          }
          {
            nix.settings = {
              substituters = [ "https://lix.cachix.org/" "https://nix-gaming.cachix.org" "https://hyprland.cachix.org" ];
              trusted-public-keys = [ 
                "lix.cachix.org-1:Jif3v4w4HXHq4DiGZKNmSQ+nSKtpLYBzQBsLNo507M8="
                "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
              ];
            };
          }
        ];

      };
    };
  };
}
