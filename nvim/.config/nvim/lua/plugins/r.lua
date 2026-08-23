-- R.nvim: the R IDE layer (successor to Nvim-R). Owns the R console, sending
-- code to it, the object browser, and R help in a buffer. This is the piece
-- that makes R usable in Neovim -- the LSP (see lsp.lua) only reads code, it
-- cannot run it.
--
-- Keymaps hang off <LocalLeader>, which is "\" (set in lua/options/init.lua).
-- The essentials:
--   \rf  start R              \rq  quit R
--   \l   send line            \d   send line, move down
--   \ss  send selection       \sd  send selection, move down
--   \pp  send paragraph       \aa  source whole file
--   \cc  send chunk           \cd  send chunk, move down   (.Rmd/.qmd/.Rnw)
--   \ch  send every chunk above the cursor
--   \ro  toggle object browser
--   \rh  R help for the word under the cursor
--   \rp / \rt   print() / str() the word under the cursor
-- In insert mode, <M--> (Alt+minus) inserts " <- ".
return {
  "R-nvim/R.nvim",
  -- Not lazy-loaded: R.nvim builds its companion R package (nvimcom) on first
  -- run and installs the filetype hooks itself.
  lazy = false,
  opts = {
    -- --no-save stops R prompting about saving .RData on every quit.
    R_args = { "--quiet", "--no-save" },

    -- Console opens as a vertical split when the editor is wide enough,
    -- horizontal below that.
    min_editor_width = 100,
    rconsole_width = 78,
  },
}
