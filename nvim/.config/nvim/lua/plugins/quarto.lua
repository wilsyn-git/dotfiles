-- Literate-document support for .qmd (Quarto) and .Rmd (R Markdown).
--
-- otter.nvim is the important half: it attaches the real language servers to
-- the code inside ``` chunks, so completion, hover and diagnostics work in a
-- document buffer instead of stopping at the fence. quarto-nvim adds the
-- render/preview commands on top (and needs the `quarto` CLI on $PATH).
return {
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto" },
    dependencies = { "jmbuhr/otter.nvim", "nvim-treesitter/nvim-treesitter" },
    opts = {
      lspFeatures = {
        languages = { "r", "python", "bash", "html" },
      },
    },
  },
  {
    "jmbuhr/otter.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- quarto-nvim activates otter for .qmd itself. R Markdown has no such
      -- plugin, so wire it up here.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserOtterRmd", { clear = true }),
        pattern = "rmd",
        callback = function()
          require("otter").activate({ "r", "python" })
        end,
      })
    end,
  },
}
