{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvidia-patch = {
      url = "github:icewind1991/nvidia-patch-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
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
      #   url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/355948.diff";
      #   sha256 = "lUYQTydR/jCyspOfoGrVpKSYujJSPZh9e6lmaOc0PQQ=";  
      # }
      {
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/369259.diff"; # umu-launcher
        sha256 = "Wigt5CMRrPVGR5foeYPFW+qi3xzdNeqnEhR1/zzaQOI=";  
      }
      {
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/368117.diff"; # suyu
        sha256 = "uCKO6nbEK+pJtTsy+vLoEUXE8vKf8mDpS+JyMTLYP44=";  
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

        specialArgs = { 
          inherit inputs system;
        };

        modules = [
          ./hosts/the-hope/configuration.nix
          ./nixos
          inputs.home-manager.nixosModules.home-manager
          # inputs.lix-module.nixosModules.default
          inputs.catppuccin.nixosModules.catppuccin
          inputs.spicetify-nix.nixosModules.default
          inputs.disko.nixosModules.disko
          {
            home-manager = {

              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit inputs; };
              
              users = {
                faustrox = {
                  imports = [
                    ./hosts/the-hope/home.nix
                    ./home
                    inputs.hyprland.homeManagerModules.default
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
