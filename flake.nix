{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable?shallow=1";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05?shallow=1";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    catppuccin.url = "github:catppuccin/nix";
    nixos-needsreboot.url = "https://flakehub.com/f/wimpysworld/nixos-needsreboot/*.tar.gz";
    nixai.url = "github:olafkfreund/nix-ai-help";

    stylix = {
      url = "github:danth/stylix";
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

    # Hyprland and desktop Flakes

    ags.url = "github:Aylur/ags";

    # hyprland.url = "github:hyprwm/Hyprland";
    # hypr-dynamic-cursors = {
    #   url = "github:VirtCode/hypr-dynamic-cursors";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # split-monitor-workspaces = {
    #   url = "github:Duckonaut/split-monitor-workspaces";
    #   inputs.hyprland.follows = "hyprland";
    # };
    
    # Multimedia & Gaming Flakes
    nix-gaming.url = "github:fufexan/nix-gaming";
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    freesmlauncher.url = "github:FreesmTeam/FreesmLauncher";
    nixcord.url = "github:kaylorben/nixcord";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    
    # Developer Flakes
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs: let
    system = "x86_64-linux";

    originPkgs = nixpkgs.legacyPackages.${system};
    pkgsPatches = [
      # {
      #   url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/367548.diff";
      #   sha256 = "sha256-N2WNRslYc3ltOEJCnJHaSoQBTS4Xfh84Qjs+/ORJPv0=";  
      # }
      # {
      #   url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/404103.diff";
      #   sha256 = "sha256-8ua6T5N3y6M7rn6U38dgPiD8+yVBm7lBfX0br+uA0rw=";  
      # }
    ];
    patchedNixpkgs = originPkgs.applyPatches {
      name = "nixpkgs-patched";
      src = nixpkgs;
      patches = map originPkgs.fetchpatch pkgsPatches;
    };

    nixosSystem = import (patchedNixpkgs + "/nixos/lib/eval-config.nix");
  in {
    nixosConfigurations = {
      the-hope = nixosSystem {
        inherit system;

        specialArgs = { 
          inherit inputs nixpkgs;
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
          inputs.nixai.nixosModules.default

          {
            nixpkgs.config.allowUnfree = true;

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
                inputs.nixcord.homeModules.nixcord
              ];
            };

            nix.settings = {
              substituters = [ "https://nix-gaming.cachix.org" "https://nix-citizen.cachix.org" "https://hyprland.cachix.org" "https://freesmlauncher.cachix.org" ];
              trusted-public-keys = [ 
                "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
                "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
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
