return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      -- ensure these language parsers are installed
      ensure_installed = {
        -- Settings lang
        "yaml",
        "toml",

        -- Backend Lang
        "lua",
        "c",
        "cpp",
        "java",

        -- Scripting Lang
        "bash",
        "python",

        -- Web Lang
        "json",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        
        -- Doc Lang
        "markdown",
        "markdown_inline",
        "vimdoc",
        "vim",

        -- Other Lang
        "dockerfile",
        "gitignore",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
