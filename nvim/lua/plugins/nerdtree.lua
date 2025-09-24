return {
  "scrooloose/nerdtree",
  dependencies = {
    "tiagofumo/vim-nerdtree-syntax-highlight",
    "ryanoasis/vim-devicons",
  },
  config = function()
    -- NERDTree settings
    vim.g.NERDTreeShowHidden = 1
    vim.g.NERDTreeMapJumpPrevSibling = ''
    vim.g.NERDTreeMapJumpNextSibling = ''

    -- Key mapping
    -- vim.keymap.set("n", "<C-n>", ":NERDTreeToggle<CR>", { noremap = true })

    -- Auto-open and auto-close behavior
    local autocmd = vim.api.nvim_create_autocmd

    autocmd('VimEnter', {
      callback = function()
        -- vim.cmd('NERDTree')
      end,
    })

    autocmd('StdinReadPre', {
      callback = function()
        -- vim.g.std_in = 1
      end,
    })

    autocmd('VimEnter', {
      callback = function()
        if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv()[1]) and not vim.g.std_in then
          -- vim.cmd('exe "NERDTree" argv()[0] | wincmd p | ene | exe "cd ".argv()[0]')
        end
      end,
    })

    autocmd('BufEnter', {
      callback = function()
        if vim.fn.winnr('$') == 1 and vim.b.NERDTree and vim.b.NERDTree.isTabTree() then
          -- vim.cmd('q')
        end
      end,
    })
  end
}
