-- Completion: blink.cmp. version = '1.*' fetches the prebuilt Rust fuzzy
-- matcher (no cargo build needed). LSP capabilities are wired in lsp.lua.
return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",
  opts = {
    keymap = {
      -- super-tab: <Tab> accepts the selected item in place (and jumps
      -- snippet placeholders when a snippet is active). Falls back to a
      -- normal <Tab> when the menu is closed.
      preset = "super-tab",
      -- <CR> accepts the selected item and then feeds a newline. When the
      -- menu is closed it falls back to a plain <CR>.
      ["<CR>"] = { "select_accept_and_enter", "fallback" },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
