-- Options, keymaps and leader (must load before lazy so plugin keymaps
-- pick up the correct <leader>).
require("options")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Import every plugin spec under lua/plugins/*.lua.
require("lazy").setup("plugins", {
  -- None of the installed plugins require luarocks, so disable lazy.nvim's
  -- rocks/hererocks support. Without this, ":checkhealth lazy" reports a
  -- spurious error about ~/.local/share/nvim/lazy-rocks/hererocks/bin/luarocks
  -- not being installed. Re-enable if you ever add a plugin with build = "rockspec".
  rocks = { enabled = false },
})
