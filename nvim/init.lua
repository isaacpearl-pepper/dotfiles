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

-- Disable vim-polyglot for Python (let treesitter handle it)
vim.g.polyglot_disabled = { "python" }

-- Disable ALE for Python (basedpyright LSP handles diagnostics)
vim.g.ale_linters_ignore = { python = { "pyright", "mypy" } }

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

-- LSP
vim.lsp.config("basedpyright", {
  cmd = { "basedpyright-langserver", "--stdio" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
  filetypes = { "python" },
  before_init = function(_, config)
    local root = config.root_dir or vim.fn.getcwd()
    local venv_python = root .. "/.venv/bin/python"
    if vim.uv.fs_stat(venv_python) then
      config.settings.python.pythonPath = venv_python
    end
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
})
vim.lsp.enable("basedpyright")

local function lsp_jump(method)
  return function()
    local pos = vim.fn.getpos(".")
    local from = { vim.fn.bufnr("%"), pos[2], pos[3], 0 }
    vim.fn.settagstack(vim.fn.win_getid(), { items = { { tagname = vim.fn.expand("<cword>"), from = from } } }, "t")
    method({
      on_list = function(options)
        if #options.items > 0 then
          local item = options.items[1]
          if item.filename then
            vim.cmd("edit " .. vim.fn.fnameescape(item.filename))
          end
          if item.lnum then
            vim.api.nvim_win_set_cursor(0, { item.lnum, (item.col or 1) - 1 })
          end
        end
      end,
    })
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "gd", lsp_jump(vim.lsp.buf.definition), opts)
    vim.keymap.set("n", "gi", lsp_jump(vim.lsp.buf.type_definition), opts)
  end,
})

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
  {
    "sivchari/claude-code.nvim",
    config = function()
      require("claude-code").setup()
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

