{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable?shallow=1";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # nix-gaming.url = "github:fufexan/nix-gaming";

    # hyprland.url = "github:hyprwm/Hyprland";
    ags.url = "github:Aylur/ags";
    catppuccin.url = "github:catppuccin/nix";
    stylix.url = "github:danth/stylix";
    
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    freesmlauncher.url = "github:FreesmTeam/FreesmLauncher";
    nixcord.url = "github:kaylorben/nixcord";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

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

  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    system = "x86_64-linux";

    originPkgs = inputs.nixpkgs.legacyPackages.${system};
    pkgsPatches = [
      # {
      #   url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/391453.diff";
      #   sha256 = "sha256-bmKan7GcWYWaX+IuGoZaGgwBAI3Ye+ZDc9ChzcfwCo4=";  
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
          inherit inputs;
        };

        modules = [
          ./hosts/the-hope/configuration.nix
          ./nixos
          ./overlays.nix
          home-manager.nixosModules.home-manager

          inputs.chaotic.nixosModules.default
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
                inputs.chaotic.homeModules.default
                inputs.catppuccin.homeModules.catppuccin
                inputs.spicetify-nix.homeManagerModules.default
                inputs.ags.homeManagerModules.default
                inputs.nvf.homeManagerModules.default
                inputs.nixcord.homeManagerModules.nixcord
              ];
            };
          }
          {
            nix.settings = {
              substituters = [ "https://nix-gaming.cachix.org" "https://hyprland.cachix.org" "https://freesmlauncher.cachix.org" ];
              trusted-public-keys = [ 
                "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                "freesmlauncher.cachix.org-1:Jcp5Q9wiLL+EDv8Mh7c6L9xGk+lXr7/otpKxMOuBuDs="
              ];
            };
          }
        ];

      };
    };
  };
}
