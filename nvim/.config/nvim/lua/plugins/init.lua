-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.g.tokyonight_style = "night"
      vim.cmd("colorscheme tokyonight")
    end,
  },

  -- Treesitter (syntax)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "vimdoc", "jsonc", "regex", "fish", 
                    "lua", "vim", "bash", "json", "python",
                    "go", "markdown", "markdown_inline", "toml",
                    "gitcommit", "gitignore", "javascript", "typescript",
                    "html", "css", "scss", "c", "cpp", "rust",
                    "java", "odin"},
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
    

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({})
    end,
  },

})
