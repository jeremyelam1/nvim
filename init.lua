require("jelam.core")
require("jelam.lazy")
require("jelam.current-theme")
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undo"
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
