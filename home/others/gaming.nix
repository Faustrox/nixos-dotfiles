{ lib, config, pkgs, inputs, ... }: let
  inherit (pkgs.stdenv.hostPlatform) system;
  umu = inputs.umu.packages.${system}.umu.override {
    withTruststore = true;
    withDeltaUpdates = true;
  };
in {

  options = {
    gaming.setup = 
      lib.mkEnableOption "Configure and install gaming packages";
  };

  config = lib.mkIf config.gaming.setup {

    home.packages = with pkgs; [

      # Social
      discord
      # vesktop

      # Emulators
      suyu

      # Launchers
      # (lutris.override {
      #   extraPkgs = pkgs: [
      #     wineWowPackages.stable
      #     winetricks
      #   ];
      # })
      prismlauncher
      heroic-unwrapped
      # arma3-unix-launcher
      umu-launcher
      cartridges
      rpcs3

      # Wine
      wineWowPackages.stable
      winetricks
      mono

      # Utils
      glfw-wayland
      goverlay
      protonup-qt
      protonup-ng
      vkbasalt
      steamcmd

    ];

    programs = {
      mangohud = {
        enable = true;
        settings = {
          round_corners = 1;
          position = "top-left";
          toggle_hud = "Shift_R+F12";
          no_display = true;
          pci_dev = "0:09:00.0";
          table_columns = 3;
          gpu_text = "RTX 3070Ti";
          gpu_stats = true;
          gpu_load_change = true;
          gpu_load_value = "50,90";
          gpu_temp = true;
          cpu_text = "R5 5600x";
          cpu_stats = true;
          core_load = true;

          font_size = lib.mkForce 16;
          font_size_text = lib.mkForce 16;

          cpu_load_change = true;
          cpu_load_value = "50,90";
          cpu_temp = true;
          swap = true;
          vram = true;
          ram = true;
          fps = true;
          fps_metrics = "avg,0.01";
          engine_version = true;
          engine_short_names = true;
          wine = true;
          frame_timing = true;
          # fps_limit_method = "early";
          # toggle_fps_limit = "Shift_R+F11";

          fps_limit = 162;
          winesync = true;
          vkbasalt = true;
          #offset=-3
          vsync = 2;
          gl_vsync = 1;
        };
      };
      java = {
        enable = true;
        package = pkgs.jdk17;
      };

      zsh.shellAliases = {
        # umu-launcher = "LD_BIND_NOW=1 STAGING_WRITECOPY=1 STAGING_SHARED_MEMORY=1 WINEDEBUG=-all ENABLE_VKBASALT=1 gamemoderun mangohud umu-run";
        dayz-launch = "$HOME/.dotfiles/home/others/scripts/dayz-launcher.sh";
        bdiscord-install = "nix run nixpkgs#betterdiscordctl install";
      };
    };

    home = {
      file = {
        ".config/vkBasalt".source = ../config/vkBasalt;
        ".steam/steam/compatibilitytools.d/Proton-GE".source = "${pkgs.proton-ge-custom}/bin";
      };
      sessionVariables = {
        WEBKIT_DISABLE_COMPOSITING_MODE = 1; # Fixes problems for logins in Lutris and other apps
      };
    };
  };
}
