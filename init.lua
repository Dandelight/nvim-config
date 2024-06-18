vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Set encoding options
vim.opt.encoding = "utf-8"
-- vim.opt.termencoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "ucs-bom", "utf-8", "chinese", "cp936" }

-- Set GUI font
vim.opt.guifont = "Cascadia Code PL Semi-Bold 14"

-- Disable undo file and backup
vim.opt.undofile = false
vim.opt.backup = false

-- Set language for messages
vim.cmd('language messages zh_CN.utf-8')

-- Set options
vim.opt.compatible = false
vim.cmd('filetype off')

-- Filetype plugin indent on
vim.cmd('filetype plugin indent on')

-- NERD Commenter settings
vim.g.NERDSpaceDelims = 1
vim.g.NERDCompactSexyComs = 1
vim.g.NERDDefaultAlign = 'left'
vim.g.NERDAltDelims_java = 1
vim.g.NERDCustomDelimiters = { c = { left = '/**', right = '*/' } }
vim.g.NERDCommentEmptyLines = 1
vim.g.NERDTrimTrailingWhitespace = 1
vim.g.NERDToggleCheckAllLines = 1

-- Leader key
vim.g.mapleader = ","
vim.api.nvim_set_keymap('n', '<leader>w', ':wa<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'wk', ':WakaTimeToday<CR>', { noremap = true })

-- General settings
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.mouse = 'a'
vim.opt.cindent = true
vim.opt.autoindent = true
vim.opt.sts = 2
vim.opt.sw = 2
vim.opt.expandtab = true
vim.opt.tw = 160
vim.cmd('colorscheme default')
vim.opt.background = 'light'
vim.cmd('colorscheme solarized')

-- User-defined shortcuts
vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<F6>', ':w<CR>:!gcc -Wall % -o %:r.dbg && ./%:r.dbg<CR>', { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n', '<F5>', ':w<CR>:!gcc -g -Wall % -o %:r.dbg && gdb ./%:r.dbg -q<CR>', { noremap = true })
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<F6>', ':w<CR>:!g++ -Wall % -o %:r.dbg && ./%:r.dbg<CR>', { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n', '<F5>', ':w<CR>:!g++ -g -Wall % -o %:r.dbg && gdb ./%:r.dbg -q<CR>', { noremap = true })
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<F6>', ':w<CR>:term node %<CR>', { noremap = true })
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<F6>', ':w<CR>:term python3 %<CR>', { noremap = true })
  end
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufReadPre"}, {
  pattern = "*.java",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<F6>', ':w<CR>:!javac %<CR>:term java %:r<CR>', { noremap = true })
  end
})

-- Custom function
vim.api.nvim_set_keymap('n', '<leader>i', ':lua Initcpp()<CR>', { noremap = true })
function Initcpp()
  local lines = {
    "#include<bits/stdc++.h>",
    "using namespace std;",
    "int main() {",
    '  // freopen("in.txt","r",stdin);',
    '  // freopen("out.txt","w",stdout);',
    "  ",
    "  return 0;",
    "}"
  }
  for i, line in ipairs(lines) do
    vim.api.nvim_buf_set_lines(0, i-1, i-1, false, { line })
  end
end

-- Remap commands
vim.api.nvim_set_keymap('n', '>', '>>', { noremap = true })
vim.api.nvim_set_keymap('n', '<', '<<', { noremap = true })
vim.api.nvim_set_keymap('i', '<c-]>', '{<CR>}<ESC>O', { noremap = true })

-- Set backspace options
vim.opt.backspace = { "indent", "eol", "start" }
