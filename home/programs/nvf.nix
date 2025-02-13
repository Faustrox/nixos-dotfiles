{ config, lib, ... }:

{

  options = {
    nvf.setup =
      lib.mkEnableOption "Enables and configure Waybar";
  };

  config = lib.mkIf config.nvf.setup {

    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          git.enable = true;
          comments.comment-nvim.enable = true;
          dashboard.dashboard-nvim.enable = true;
          filetree.neo-tree.enable = true;
          statusline.lualine.enable = true;
          telescope.enable = true;
          autocomplete.nvim-cmp.enable = true;
          utility.surround.enable = true;

					options = {
						tabstop = 2;
						softtabstop = 2;
						shiftwidth = 2;
					};

          lsp = {
            enable = true;
            lspkind.enable = true;
            lsplines.enable = true;
            lspsaga.enable = true;
            lspSignature.enable = true;
            null-ls.enable = true;
            otter-nvim.enable = true;
            trouble.enable = true;
          };

          theme = {
            enable = true;
            name = "catppuccin";
            style = "mocha";
          };

          languages = {
            enableLSP = true;
            enableTreesitter = true;

            bash.enable = true;
            html.enable = true;
            nix.enable = true;
            ts.enable = true;
            css.enable = true;
          };
        };
      };
    };

  };

}
