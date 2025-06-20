{ pkgs, lib, config, ... }:

{
  options = {
    vscode.setup = lib.mkEnableOption 
      "Enable and configure vscode";
  };

  config = lib.mkIf config.vscode.setup {

    home.packages = with pkgs; [
      nixfmt-rfc-style
      nil
    ];

    programs.vscode = {
      enable = true;

      profiles.default = {
        extensions = with pkgs.vscode-marketplace; [
          mads-hartmann.bash-ide-vscode
          catppuccin.catppuccin-vsc-icons
          catppuccin.catppuccin-vsc
          naumovs.color-highlight
          eamodio.gitlens
          oderwat.indent-rainbow
          jnoortheen.nix-ide
          usernamehw.errorlens
          tamasfe.even-better-toml
          xabikos.javascriptsnippets
          formulahendry.auto-rename-tag
          # brandonkirbyson.vscode-animations
          # subframe7536.custom-ui-style
        ];

        userSettings = {
          "editor.fontFamily" = "FiraCode Nerd Font";
          "editor.fontWeight" = "normal";
          "editor.lineHeight" = 20;
          "editor.letterSpacing" = 0.5;
          "editor.fontLigatures" = true;
          "editor.wordWrap" = "on";
          "editor.tokenColorCustomizations" = {
            "textMateRules" = [
              {
                "name" = "Italic words";
                "scope" = [
                  "comment"
                  "entity.name.type.class"
                  "entity.other.attribute-name"
                  "keyword"
                  "support.class.builtin"
                  "variable.language.this"
                  "storage.modifier"
                  "storage.type.class"
                  "storage.type.function"
                  "storage.type"
                  "keyword.control.import"
                  "keyword.control.from"
                  "keyword.control.flow"
                  "keyword.control.conditional"
                  "keyword.control.loop"
                  "keyword.operator.new"
                ];
                "settings" = {
                  "fontStyle" = "italic";
                };
              }
              {
                "name" = "Bold";
                "scope" = [
                  "entity.name.type.class"
                  "entity.other.attribute-name"
                  "keyword"
                  "support.class.builtin"
                  "variable.language.this"
                  "storage.modifier"
                  "storage.type.class"
                  "storage.type.function"
                  "storage.type"
                  "keyword.control.import"
                  "keyword.control.from"
                  #"entity.name.type"
                  "keyword.control.flow"
                  "keyword.control.conditional"
                  "keyword.control.loop"
                  "keyword.operator.new"
                  "constant.language"
                ];
                "settings" = {
                  "fontStyle" = "bold";
                };
              }
              {
                "name" = "To not affect any";
                "scope" = [
                  "invalid"
                  "keyword.operator"
                  "constant.numeric.css"
                  "keyword.other.unit.px.css"
                  "constant.numeric.decimal"
                  "constant.numericon"
                  "entity.name.type.class"
                ];
                "settings" = {};
              }
            ];
          };
          "editor.cursorBlinking" = "expand";
          "explorer.confirmDelete" = false;
          "security.workspace.trust.untrustedFiles" = "open";
          "editor.unicodeHighlight.invisibleCharacters" = false;
          "editor.bracketPairColorization.enabled" = true;
          "editor.guides.bracketPairs" = "active";
          "typescript.updateImportsOnFileMove.enabled" = "always";
          "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
          "javascript.updateImportsOnFileMove.enabled" = "always";
          "explorer.confirmDragAndDrop" = false;
          "window.commandCenter" = false;
          "window.titleBarStyle" = "custom";
          "editor.stickyScroll.enabled" = true;
          "terminal.integrated.env.windows" = {};
          "editor.tabSize" = 2;
          "editor.codeLensFontFamily" = "FiraCode Nerd Font";
          "editor.fontVariations" = true;
          "javascript.preferences.quoteStyle" = "single";
          "typescript.preferences.quoteStyle" = "single";
          "javascript.format.semicolons" = "remove";
          "typescript.format.semicolons" = "remove";
          "template-string-converter.quoteType" = "single";
          "remote.autoForwardPortsSource" = "hybrid";
          "workbench.tree.enableStickyScroll" = true;
          "symbols.hidesExplorerArrows" = false;
          "editor.inlineSuggest.suppressSuggestions" = true;
          # "workbench.productIconTheme" = "fluent-icons";
          "editor.minimap.enabled" = false;
          "workbench.sideBar.location" = "right";
          "workbench.editor.editorActionsLocation" = "hidden";
          "workbench.startupEditor" = "none";
          "workbench.colorTheme" = "Catppuccin Mocha";
          "window.menuBarVisibility" = "compact";
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = {
            "nil" = {
              "nix" = {
                "binary" = "nix";
                "maxMemoryMB" = 2560;
                "flake" = {
                  "autoArchive" = true;
                  "autoEvalInputs" = false;
                  "nixpkgsInputName" = "nixpkgs";
                };
              };
            };
          };
          "workbench.activityBar.location" = "hidden";
          "editor.semanticHighlighting.enabled" = true;
          "terminal.integrated.minimumContrastRatio" = 1;
          "gopls" = {
            "ui.semanticTokens" = true;
          };
          "catppuccin.bracketMode" = "neovim";
          "catppuccin.customUIColors" = {
            "mocha" = {
              "statusBar.foreground" = "accent";
            };
          };
          "catppuccin.accentColor" = "sapphire";
          "workbench.iconTheme" = "catppuccin-mocha";
          "animations.Auto-Install" = false;
          "animations.Install-Method" = "Custom UI Style";
          "custom-ui-style.external.imports" = [
            "file:///home/faustrox/.vscode/extensions/brandonkirbyson.vscode-animations/dist/updateHandler.js"
          ];
        };
      };
    };
  };
}