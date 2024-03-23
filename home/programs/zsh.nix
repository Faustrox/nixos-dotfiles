{ config, lib, pkgs, ... }:

{

  options = {
    zsh.setup = 
      lib.mkEnableOption "Enables and configure zsh";
  };

  config = lib.mkIf config.zsh.setup {

    programs = {
      bat.enable = true;
      fastfetch.enable = true;
      fd.enable = true;

      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        initExtra = ''
          export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
          export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
          export FZF_DEFAULT_OPTS=" \
            --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
            --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
            --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
            --color=selected-bg:#45475a \
            --multi"

          _fzf_compgen_path() {
            fd --hidden --exclude .git . "$1"
          }

          _fzf_compgen_dir() {
            fd --type=d --hidden --exclude .git . "$1"
          }

          _fzf_comprun() {
            local command=$1
            shift

            case "$command" in
              cd)   fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
              export|unset) fzf --preview "eval 'echo \$' {}" "$@" ;;
              ssh) fzf --preview 'dig {}' "$@" ;;
              *) fzf --preview "--preview 'bat -n --color=always --line-range= :500 {}'" "$@" ;;
            esac
          }

          source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
        '';

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
            name = "fzf-tab";
            src = pkgs.zsh-fzf-tab;
            file = "share/fzf-tab/fzf-tab.plugin.zsh";
          }
          {
            name = "powerlevel10k-config";
            src = ./scripts;
            file = "./p10k-config.sh";
          }
        ];

        shellAliases = {
          ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
          cd = "z";
          nixos-switch = "nh os switch";
          nixos-boot = "nh os boot";
          nixos-switch-update = "nh os switch --update";
          nixos-boot-update = "nh os boot --update";
          nixos-clean = "nh clean all";
        };
      };

      # ZSH Integrations

      thefuck = {
        enable = true;
        enableZshIntegration = true;
      };
      
      eza = {
        enable = true;
        enableZshIntegration = true;
        git = true;
        icons = true;
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
        defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
      };
      
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };


    home.packages = with pkgs; [
      zsh-fzf-tab
      fzf-git-sh
    ];

  };

}