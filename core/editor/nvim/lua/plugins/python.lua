-- lua/plugins/python.lua
-- Python + Django setup for LazyVim
-- Assumes lang.python extra is enabled via lazyvim.json

return {
  -- Virtual environment selector
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    branch = "regexp",
    opts = {
      settings = {
        search = {
          venvs_path = vim.fn.expand("~/"),
        },
      },
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
    },
  },

  -- Django template syntax
  {
    "Glench/Vim-Jinja2-Syntax",
    ft = { "html", "jinja", "htmldjango" },
  },

  -- Treesitter grammars
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "python",
        "htmldjango",
        "html",
        "toml",
      })
      return opts
    end,
  },

  -- pyright tuned for Django
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
      },
    },
  },

  -- ruff as formatter, djlint for templates
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { "ruff_format" }
      opts.formatters_by_ft.htmldjango = { "djlint" }
      return opts
    end,
  },
}
