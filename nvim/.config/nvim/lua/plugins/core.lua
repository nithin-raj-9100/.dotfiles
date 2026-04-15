return {
  -- Configure LazyVim
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },

  -- Tmux pane navigation from within Neovim
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },

  -- File Explorer: Show hidden and ignored files by default
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
            layout = {
              layout = {
                position = "right",
              },
            },
          },
          files = {
            hidden = true,
          },
        },
      },
    },
  },

  -- LSP: Disable inlay hints (remove the "path:" labels)
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
    },
  },
}
