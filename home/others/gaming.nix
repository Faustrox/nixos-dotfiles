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

  nix-gaming = inputs.nix-gaming.packages.${pkgs.hostPlatform.system};

in {

  options = {
    gaming.setup = 
      lib.mkEnableOption "Configure and install gaming packages";
  };

  config = lib.mkIf config.gaming.setup {

    home.packages = with pkgs; [

      (pkgs.writers.writeBashBin "gamix" ''
  
        export LD_PRELOAD="" WINEDEBUG=-all WINEDLLOVERRIDES="$WINEDLLOVERRIDES;winmm=n,b" \
                MANGOHUD=1 ENABLE_VKBASALT=1

        exec "$@"

      '')

      # Social
      # discord
      # vesktop

      # Emulators
      suyu
      rpcs3

      # Launchers
      prismlauncher
      heroic-unwrapped
      umu-launcher
      cartridges

      # Wine
      wineWowPackages.stagingFull
      winetricks
      mono

      # Utils
      exiftool
      glfw-wayland
      goverlay
      protonplus
      protonup-qt
      protonup-ng
      vkbasalt
      steamcmd

    ];

    programs = {
      nixcord = {
        enable = true;
        discord.enable = false;
        vesktop.enable = true;
        config.frameless = true;
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
          fps_metrics = "0.01";
          engine_version = true;
          engine_short_names = true;
          wine = true;
          frame_timing = true;
          fps_limit_method = "late";
          toggle_fps_limit = "Shift_R+F11";
          toggle_hud_position = "Shift_R+F10";

          fps_limit = "0,162,120,90";
          winesync = true;
          vkbasalt = true;
          # gamemode = true;
          # offset=-3
          vsync = 2;
          gl_vsync = 1;
        };
      };
      java = {
        enable = true;
        package = pkgs.jdk17;
      };

    };

    xdg.configFile."vkBasalt".source = ../config/vkBasalt;

    home = {
      file = {
        ".steam/steam/compatibilitytools.d/Proton-GE".source = "${pkgs.proton-ge-custom}/bin";
        ".steam/steam/compatibilitytools.d/Proton-CachyOS".source = "${pkgs.proton-cachyos-custom}/bin";
      };
      sessionVariables = {
        # WEBKIT_DISABLE_COMPOSITING_MODE = 1; # Fixes problems for logins in Lutris and other apps
      };
    };
  };
}
