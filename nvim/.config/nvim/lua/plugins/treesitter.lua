-- Treesitter (syntax) -- 'main' branch: required for Neovim 0.11+
return {
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
}
