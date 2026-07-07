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

  -- Treesitter (syntax) -- 'main' branch: required for Neovim 0.11+
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local langs = {
        "lua", "luadoc", "vim", "vimdoc", "query", "regex",
        "bash", "fish", "tmux",
        "json", "toml", "yaml", "csv",
        "python", "go", "rust", "c", "cpp", "odin", "swift", "java",
        "javascript", "typescript", "html", "css", "scss",
        "markdown", "markdown_inline",
        "diff", "git_config", "gitcommit", "gitignore", "requirements",
      }

      -- Install/update the parsers (async; runs in the background).
      require("nvim-treesitter").install(langs)

      -- The 'main' branch no longer wires up highlight/indent for you;
      -- enable them per-buffer whenever a parser is available.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft) or ft
          local ok, added = pcall(vim.treesitter.language.add, lang)
          if ok and added then
            vim.treesitter.start(args.buf, lang)
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
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

}, {
  -- None of the installed plugins require luarocks, so disable lazy.nvim's
  -- rocks/hererocks support. Without this, ":checkhealth lazy" reports a
  -- spurious error about ~/.local/share/nvim/lazy-rocks/hererocks/bin/luarocks
  -- not being installed. Re-enable if you ever add a plugin with build = "rockspec".
  rocks = { enabled = false },
})
