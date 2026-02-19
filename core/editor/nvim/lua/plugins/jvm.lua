-- JVM Stack — Groovy / Grails / Java
-- Requires: mason.nvim, nvim-lspconfig (both ship with LazyVim)
return {
  -- Mason: installs LSP servers, linters, formatters
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "groovy-language-server", -- Groovy LSP
        "google-java-format", -- Java/Groovy formatter
      },
    },
  },

  -- LSP config: wire up the Groovy language server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        groovyls = {
          -- groovy-language-server picks up SDKMAN!'s active JDK automatically
          cmd = { "groovy-language-server" },
          filetypes = { "groovy" },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(
              "build.gradle",
              "build.gradle.kts",
              "settings.gradle",
              "grails-app",
              ".git"
            )(fname)
          end,
          settings = {
            groovy = {
              classpath = {},
            },
          },
        },
      },
    },
  },

  -- conform.nvim: formatting for Java and Groovy
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.java = { "google-java-format" }
      opts.formatters_by_ft.groovy = { "google-java-format" }
      return opts
    end,
  },
}
