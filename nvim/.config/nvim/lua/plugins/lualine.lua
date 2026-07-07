-- Statusline: lualine, themed to match Tokyo Night.
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      theme = "tokyonight",
    },
  },
}
