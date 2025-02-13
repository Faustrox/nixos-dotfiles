{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    catppuccin.url = "github:catppuccin/nix";
    stylix.url = "github:danth/stylix";
    ags.url = "github:Aylur/ags";
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    nixcord.url = "github:kaylorben/nixcord";
    
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvidia-patch = {
      url = "github:icewind1991/nvidia-patch-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # lix-module = {
    #   url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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
     # {
       # url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/371640.diff"; # suitesparse fix
       # sha256 = "S4zTab4Mpsr3if4CANbeEUaEWcVTxTONbHKojIK7XZ4=";  
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
          # inputs.lix-module.nixosModules.default
          inputs.catppuccin.nixosModules.catppuccin
          inputs.spicetify-nix.nixosModules.default
          inputs.disko.nixosModules.disko
          inputs.stylix.nixosModules.stylix
          {
            home-manager = {
              users.faustrox = import ./hosts/the-hope/home.nix;

              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
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
        ];

      };
    };
  };
}
