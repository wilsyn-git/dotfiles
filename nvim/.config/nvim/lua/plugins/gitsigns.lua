-- Git: gitsigns (signs in the gutter, hunk actions, blame). Default setup.
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
}
