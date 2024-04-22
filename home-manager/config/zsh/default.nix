{ config, lib, pkgs, ... }:

{

  options = {
    zsh.enable = 
      lib.mkEnableOption "Enables and configure zsh";
  };

  config = lib.mkIf config.zsh.enable {

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };

      plugins = [
        { 
          name = "powerlevel10k"; 
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = ./p10k-config;
          file = "./p10k.zsh";
        }
      ];

      shellAliases = {
        ll = "ls -l";
        rebuild = "nh os switch";
        update = "nh os switch --update";
        remove-old = "nh clean all --keep 5 --dry";
        dayz-launch = "STEAM_ROOT=/mnt/games/Libreries/Steam /mnt/games/Libreries/Others/DayZ\ Linux\ Launcher/dayz-launcher.sh";
      };
      
    };

  };

}