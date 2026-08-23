local opt   = vim.opt
local g     = vim.g
local cmd   = vim.cmd
local fn    = vim.fn
local api   = vim.api
local keymap = vim.keymap
local data = fn.stdpath("data")



g.mapleader = " "
-- LocalLeader is deliberately NOT <Space>: R.nvim hangs its entire keymap set
-- off <LocalLeader> (\d send line, \ss send selection, \cc send chunk, ...),
-- which would shadow the <Space>-prefixed mappings below inside R buffers.
-- Backslash also matches every Nvim-R/R.nvim tutorial and cheatsheet.
g.maplocalleader = "\\"

keymap.set("n","<leader>w", ":w<CR>")
keymap.set("n","<leader>q", ":q<CR>")
-- <leader>e opens Oil (defined in lua/plugins/oil.lua), replacing :Ex/netrw.
keymap.set("n","<leader>tw", ":set wrap!<CR>")

keymap.set("n","<leader>ff", "<cmd>Telescope find_files<cr>")
keymap.set("n","<leader>fg", "<cmd>Telescope live_grep<cr>")
keymap.set("n","<leader>fb", "<cmd>Telescope buffers<cr>")
keymap.set("n","<leader>fh", "<cmd>Telescope help_tags<cr>")

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.termguicolors = true

opt.wrap = false
opt.scrolloff = 8

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

opt.clipboard = "unnamedplus"

opt.backup = false
opt.writebackup = false

opt.swapfile = true
opt.undofile = true

opt.directory = data .. "/swap//"
opt.undodir = data .. "/undo//"
opt.backupdir = data .. "/backup//"

opt.updatetime = 250
opt.timeoutlen = 400

