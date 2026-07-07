-- Completion: blink.cmp. version = '1.*' fetches the prebuilt Rust fuzzy
-- matcher (no cargo build needed). LSP capabilities are wired in lsp.lua.
return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",
  opts = {
    keymap = { preset = "default" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
