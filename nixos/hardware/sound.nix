{ config, lib, pkgs, inputs, ... }:

{

  options = {
    hardware.sound.setup =
      lib.mkEnableOption "Enables and configure sound.";
  };

  config = lib.mkIf config.hardware.sound.setup {

    environment.systemPackages = with pkgs; [
      pavucontrol
      headsetcontrol
      easyeffects
    ];

    programs.noisetorch.enable = false;

    services.udev = {
      extraRules = ''
        # This is for real time audio
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
        KERNEL=="cpu_dma_latency", GROUP="audio"
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      '';
      packages = with pkgs; [ headsetcontrol ];
    };

    security.rtkit = {
      enable = true;
      args = [
        "--scheduling-policy=FIFO"
        "--our-realtime-priority=89"
        "--max-realtime-priority=88"
        "--min-nice-level=-19"
        "--rttime-usec-max=2000000"
        "--users-max=100"
        "--processes-per-user-max=1000"
        "--threads-per-user-max=10000"
        "--actions-burst-sec=10"
        "--actions-per-burst-max=1000"
        "--canary-cheep-msec=30000"
        "--canary-watchdog-msec=60000"
      ];
    };
    
    services = {
      pulseaudio.enable = false;
      
      pipewire = {
        enable = true;
        # alsa.enable = true;
        # alsa.support32Bit = true;
        pulse.enable = true;
        extraConfig.pipewire = { # Using wireless headset, letting pipewire to process
          "10-clock-rate" = {
            "context.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.quantum" = 3600;
              "default.clock.force-quantum" = 3600;
            };
          };
        };
        extraConfig.pipewire-pulse = {
          "99-buffer" = {
            "pulse.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.quantum" = 3600;
              "default.clock.force-quantum" = 3600;
            };
          };
        };
        wireplumber.extraConfig.bluetoothEnhancements = {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.hfphsp-backend" = "native";
            
            "bluez5.roles" = [ "a2dp_sink" "a2dp_source" "bap_sink" "bap_source" "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
            "bluez5.codecs" = [
              "ldac"
              "aptx"
              "aptx_ll_duplex"
              "aptx_ll"
              "aptx_hd"
              "opus_05_pro"
              "opus_05_71"
              "opus_05_51"
              "opus_05"
              "opus_05_duplex"
              "aac"
              "sbc_xq"
            ];
          };
        };
      };
    };
  };
}
