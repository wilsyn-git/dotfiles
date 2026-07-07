-- File explorer: oil.nvim (edit the filesystem like a buffer).
-- <leader>e (formerly :Ex/netrw) now opens Oil.
return {
  "stevearc/oil.nvim",
  opts = {},
  -- Load eagerly so Oil can replace netrw as the default directory handler.
  lazy = false,
  keys = {
    { "<leader>e", "<cmd>Oil<cr>", desc = "Open Oil (file explorer)" },
  },
}
