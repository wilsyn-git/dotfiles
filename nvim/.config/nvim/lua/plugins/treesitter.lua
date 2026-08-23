-- Treesitter (syntax) -- 'main' branch: required for Neovim 0.11+
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local langs = {
      "lua", "luadoc", "vim", "vimdoc", "query", "regex",
      -- (nvim-treesitter's `main` branch dropped the tmux grammar; leaving it
      -- in the list only produced an "unsupported language" warning on startup.)
      "bash", "fish",
      "json", "toml", "yaml", "csv",
      "python", "go", "rust", "c", "cpp", "odin", "swift", "java",
      -- R: `r` also powers the code-chunk injections inside .Rmd/.qmd, and
      -- `rnoweb`/`latex` cover Sweave (.Rnw) documents.
      "r", "rnoweb", "latex",
      "javascript", "typescript", "html", "css", "scss",
      "markdown", "markdown_inline",
      "diff", "git_config", "gitcommit", "gitignore", "requirements",
    }

    -- Install/update the parsers (async; runs in the background).
    require("nvim-treesitter").install(langs)

    -- There is no `rmd` or `quarto` grammar; both are Markdown with typed code
    -- fences. Point those filetypes at the markdown parser so they get real
    -- highlighting (and R chunk injections) instead of falling through to the
    -- bundled regex syntax. (R.nvim does this too, but keeping it here means
    -- .Rmd/.qmd still highlight correctly if that plugin is ever removed.)
    vim.treesitter.language.register("markdown", { "rmd", "quarto" })

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
}
