-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
    de
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before loading plugins
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Global Neovim configuration
local opt = vim.opt
local keymap = vim.keymap
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General options
opt.mouse = "a"
opt.clipboard = "unnamed"
opt.encoding = "UTF-8"
opt.number = true
opt.relativenumber = false
opt.signcolumn = "yes"
opt.cmdheight = 2
opt.updatetime = 300
opt.shortmess:append("c")
opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.hidden = true
opt.completeopt = { "menuone", "noselect" }

-- Colors and theme
vim.cmd("syntax enable")
opt.background = "dark"
vim.cmd("colorscheme lanox_custom")

-- Enable filetype plugins
vim.cmd("filetype plugin on")
vim.cmd("syntax on")

-- FZF
opt.rtp:append("/opt/homebrew/opt/fzf")

-- Key mappings
local opts = { noremap = true, silent = true }

-- Window movement
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Line movement (scrolling)
keymap.set("n", "<S-K>", "2<C-Y>", opts)
keymap.set("n", "<S-J>", "2<C-E>", opts)

-- Insert mode escape
keymap.set("i", "jk", "<Esc>", opts)

-- FZF and buffers
keymap.set("n", "<C-p>", ":FZF<CR>", opts)
keymap.set("n", "<C-b>", ":Buffers<CR>", opts)

-- Autocommands
local numbertoggle = augroup('numbertoggle', { clear = true })

autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  group = numbertoggle,
  callback = function()
    if vim.wo.number and vim.fn.mode() ~= 'i' then
      vim.wo.relativenumber = true
    end
  end,
})

autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  group = numbertoggle,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
})

-- Global functions
function _G.SynStack()
  if not vim.fn.exists('*synstack') then
    return
  end
  local stack = vim.fn.synstack(vim.fn.line('.'), vim.fn.col('.'))
  local names = {}
  for _, id in ipairs(stack) do
    table.insert(names, vim.fn.synIDattr(id, 'name'))
  end
  print(vim.inspect(names))
end

keymap.set("n", "<leader>sp", ":lua SynStack()<CR>", opts)

-- if vim.fn.argc(-1) == 0 then
--   vim.cmd("NvimTreeOpen")
-- end
--
--
keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true })

-- Setup lazy.nvim
require("lazy").setup({
  -- Basic plugins that don't need configuration
  "jiangmiao/auto-pairs",
  -- "adelarsq/vim-emoji-icon-theme",
  "buoto/gotests-vim",
  "sheerun/vim-polyglot",
  "jparise/vim-graphql",
  "prettier/vim-prettier",
  "christoomey/vim-tmux-navigator",
  "dense-analysis/ale",
  "glacambre/firenvim",
  "wesQ3/vim-windowswap",

  -- SQL settings
  {
    "vim-scripts/sql.vim",
    config = function()
      vim.g.sql_type_default = 'pqsql'
    end
  },

  -- Load plugins from separate files
  { import = "plugins" },
}, {
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "lanox_custom", "habamax" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
