{ lib, config, pkgs, inputs, ... }: let

  # wineprefix-preparer = (pkgs.writers.writeBashBin "wineprefix-preparer" ''
  #   if ! command -v winepath; then
  #   >&2 echo "$(basename "$0"): No winepath binary in path. Run with wine available"
  #   exit 1
  #   fi
  #   export WINEPREFIX="''${WINEPREFIX:-$HOME/.wine}"
  #   echo "Preparing prefix $WINEPREFIX for gaming"

  #   set -euo pipefail

  #   echo "Killing running wine processes/wineserver"
  #   wineserver -k || true

  #   echo "Running wineboot -u to update prefix"
  #   WINEDEBUG=-all wineboot -u; sleep 1

  #   echo "Stopping processes in session"
  #   wineserver -k || true

  #   win64_sys_path=$(wine64 winepath -u 'C:\windows\system32' 2> /dev/null)
  #   win64_sys_path="''${win64_sys_path/$'\r'/}"
  #   win32_sys_path=$(wine winepath -u 'C:\windows\system32' 2> /dev/null)
  #   win32_sys_path="''${win32_sys_path/$'\r'/}"

  #   echo "Found 32 bit path $win32_sys_path and 64 bit path $win64_sys_path"

  #   echo "Removing existing dxvk and vkd3d-proton DLLs"
  #   rm -rf {"$win32_sys_path","$win64_sys_path"}/{dxgi,d3d9,d3d10core,d3d11,d3d12}.dll

  #   winetricks dxvk vkd3d-proton

  #   echo "Adding native DllOverrides"
  #   for dll in dxgi d3d9 d3d10core d3d11 d3d12; do
  #     wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v $dll /d native /f >/dev/null 2>&1
  #   done
  # '');

  freesmlauncher = inputs.freesmlauncher.packages.${pkgs.system}.default;

in {

  options = {
    gaming.setup = 
      lib.mkEnableOption "Configure and install gaming packages";
  };

  config = lib.mkIf config.gaming.setup {

    home.packages = with pkgs; [

      (pkgs.writers.writeBashBin "gamix" ''

        set -euo pipefail

        MANGOHUD=1
        SDL=1
        FORCE_WAYLAND=0
        USE_GAMESCOPE=0
        USE_UMU=0
        DEFAULT_PREFIX="$HOME/.umu-game"
        DEFAULT_PROTON="${pkgs.proton-ge-custom}/bin"
        OPENGL=0

        REMAINING_ARGS=()

        if [[ " $* " == *" --help "* ]]; then
          echo "Use: gamix [--no-hud] [--no-sdl] [--wine-wayland] [--gamescope] [--umu] [--prefix] [--proton] [--opengl] %command%"
          exit 0
        fi

        while [[ $# -gt 0 ]]; do
          case "$1" in
            --no-hud)
              MANGOHUD=0
            ;;
            --wine-wayland)
              FORCE_WAYLAND=1
            ;;
            --no-sdl)
              SDL=0
            ;;
            --gamescope)
              USE_GAMESCOPE=1
            ;;
            --umu)
              USE_UMU=1
            ;;
            --prefix)
              shift
              DEFAULT_PREFIX="$1"
            ;;
            --proton)
              shift
              DEFAULT_PROTON="$1"
            ;;
            --opengl)
              OPENGL=1
            ;;
            *)
              REMAINING_ARGS+=("$1")
            ;;
          esac
          shift
        done

        export ENABLE_VKBASALT=1
        export __GL_SHADER_DISK_CACHE=1
        export PROTON_ENABLE_WAYLAND="$FORCE_WAYLAND"

        export DXVK_CONFIG_FILE="$HOME/Games/dxvk.conf"
        export __GL_THREADED_OPTIMIZATIONS=$((1 - OPENGL))

        if [ "$SDL" -eq 0 ]; then
          unset SDL_VIDEODRIVER
        fi

        CMD=("${pkgs.uwsm}/bin/uwsm-app" "--")

        if [ "$USE_GAMESCOPE" -eq 1 ]; then
          CMD+=("${pkgs.gamescope}/bin/gamescope" "--force-grab-cursor" "--")
        fi

        if [ "$MANGOHUD" -eq 1 ]; then
          export MANGOHUD=1
          export MANGOHUD_OPENGL_LIBS="${pkgs.mangohud}/lib/mangohud/libMangoHud_opengl.so"
          export LD_PRELOAD="''${LD_PRELOAD:+$LD_PRELOAD:}${pkgs.mangohud}/lib/mangohud/libMangoHud.so:${pkgs.mangohud}/lib/mangohud/libMangoHud_opengl.so"

          if [ "$OPENGL" -eq 1 ]; then
            CMD+=("${pkgs.mangohud}/bin/mangohud" "--dlsym")
          else
            CMD+=("${pkgs.mangohud}/bin/mangohud")
          fi
        fi

        if [ "$USE_UMU" -eq 1 ]; then
          export WINEPREFIX="$DEFAULT_PREFIX"
          export PROTONPATH="$DEFAULT_PROTON"

          CMD+=("${pkgs.umu-launcher}/bin/umu-run")
        fi

        CMD+=("''${REMAINING_ARGS[@]}")

        exec "''${CMD[@]}"

      '')

      # Social
      # discord
      # vesktop

      # Emulators
      ryubing
      # suyu
      # rpcs3

      # Launchers
      # (lutris.override {
      #   extraPkgs = pkgs: [
      #     wineWowPackages.stableFull
      #   ];
      # })
      mcpelauncher-client
      freesmlauncher
      heroic-unwrapped
      umu-launcher
      cartridges
      mgba

      # Wine
      # mono

      # Utils
      nvibrant_git
      gamepad-tool
      antimicrox
      glfw3-minecraft
      exiftool
      goverlay
      protonplus
      protonup-qt
      protonup-ng
      vkbasalt
      steamcmd

    ];

    programs = {
      java = {
        enable = true;
        package = pkgs.zulu;
      };

      nixcord = {
        enable = true;
        discord.enable = false;
        vesktop.enable = true;

        config = {
          frameless = true; # set some Vencord options
          themeLinks = [
            "https://catppuccin.github.io/discord/dist/catppuccin-mocha-mauve.theme.css"
          ];
        };
      };

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

          font_size = lib.mkForce 16;
          font_size_text = lib.mkForce 16;

          cpu_text = "R5 5600x";
          cpu_stats = true;
          cpu_load_change = true;
          cpu_load_value = "50,90";
          cpu_temp = true;
          cpu_power = true;
          core_load = true;
          swap = true;
          vram = true;
          ram = true;
          fps = true;
          fps_value = "60,144";
          fps_color_change = true;
          fps_color = lib.mkForce "f38ba8,f9e2af,a6e3a1";
          fps_metrics = "avg,0.01";
          engine_version = true;
          engine_short_names = true;
          wine = true;
          frame_timing = true;
          fps_limit_method = "early";
          toggle_fps_limit = "Shift_R+F11";
          toggle_hud_position = "Shift_R+F10";
          fps_limit = "165,120,90";
          show_fps_limit = true;
          
          winesync = true;
          vkbasalt = true;
          # gamemode = true;
          # offset=-3
          vsync = 0;
          gl_vsync = 1;
        };
      };
    };
    home.shellAliases = {
      run-exe = "WINEPREFIX=~/.umu-exe PROTONPATH=${pkgs.proton-ge-custom}/bin umu-run"; # Using umu
    };

    stylix.targets = {
      nixcord.enable = false;
      vencord.enable = false;
    };

    xdg.configFile."vkBasalt".source = ../config/vkBasalt;

    home = {
      file = {
        ".steam/steam/compatibilitytools.d/Proton-GE/".source = "${pkgs.proton-ge-custom}/bin";
      };
      
      sessionVariables = {
        # WEBKIT_DISABLE_COMPOSITING_MODE = 1; # Fixes problems for logins in Lutris and other apps
      };
    };
  };
}
