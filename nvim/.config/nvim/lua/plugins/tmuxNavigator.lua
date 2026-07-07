-- Seamless navigation between Neovim splits and tmux panes with <C-h/j/k/l>.
-- The tmux side of the integration is already installed.
return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left (nvim/tmux)" },
    { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down (nvim/tmux)" },
    { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up (nvim/tmux)" },
    { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right (nvim/tmux)" },
    { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Navigate previous (nvim/tmux)" },
  },
}
