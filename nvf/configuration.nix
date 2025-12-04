{ pkgs, ... }:

let
  enabled = {
    enable = true;
  };
in
{
  programs.nvf = enabled // {
    settings.vim = {
      autocomplete.blink-cmp = enabled // {
        setupOpts = {
          cmdline.keymap.preset = "super-tab";

          keymap."<C-k>" = [
            "show_signature"
            "hide_signature"
            "fallback"
          ];

          signature.enabled = true;

          sources.default = [
            "lsp"
            "path"
            "buffer"
          ];
        };
      };

      clipboard = enabled // {
        providers.wl-copy = enabled;
      };

      comments.comment-nvim = enabled;

      diagnostics = enabled // {
        config = {
          signs = true;
          virtual_text = true;
        };
      };

      extraLuaFiles = [
        ./after/ftplugin/nix.lua
      ];

      extraPlugins = with pkgs.vimPlugins; {
        blink-pairs = {
          package = blink-pairs;
          setup = ''require("blink.pairs").setup({})'';
        };
      };

      filetree.nvimTree = enabled // {
        setupOpts = {
          diagnostics = enabled;
          disable_netrw = true;
          hijack_cursor = true;
        };
      };

      languages = {
        enableTreesitter = true;

        assembly = enabled;
        clang = enabled;
        css = enabled;
        html = enabled;
        java = enabled;
        markdown = enabled;
        nix = enabled;
        python = enabled;
        rust = enabled // {
          extensions.crates-nvim = enabled;
        };
        tailwind = enabled;
        ts = enabled;
        typst = enabled;
      };

      lineNumberMode = "number";

      lsp = enabled // {
        inlayHints = enabled;
      };

      options = {
        background = "dark";
        cursorline = true;
        expandtab = true;
        number = true;
        shiftwidth = 4;
        showmode = false;
        tabstop = 4;
        tm = 200;
        wrap = false;
      };

      presence.neocord = enabled;

      preventJunkFiles = true;

      statusline.lualine = enabled;

      telescope = enabled // {
        extensions = [
          {
            name = "fzf";
            packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
            setup = {
              fzf = {
                fuzzy = true;
              };
            };
          }
        ];
      };

      terminal.toggleterm = enabled // {
        setupOpts = {
          direction = "float";
          size = 10;
        };
      };

      theme = enabled // {
        name = "tokyonight";
        style = "night";
      };

      ui.colorizer = enabled // {
        setupOpts.filetypes."*" = {
          RGB = true;
          RRGGBB = true;
          RRGGBBAA = true;
        };
      };

      visuals = {
        fidget-nvim = enabled;
        indent-blankline = enabled;
        nvim-web-devicons = enabled;
      };
    };
  };
}
