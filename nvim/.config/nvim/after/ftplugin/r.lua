-- The global default is 4 spaces; R's community style (tidyverse, and air's
-- default) is 2, with an 80-column line limit. Match it so `air` reformatting
-- and hand-written code agree.
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.textwidth = 80
vim.opt_local.colorcolumn = "80"
