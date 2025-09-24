return {
  "neoclide/coc.nvim",
  branch = "release",
  config = function()
    -- CoC global extensions
    vim.g.coc_global_extensions = { 'coc-tsserver' }

    -- CoC key mappings
    local keymap = vim.keymap
    local opts = { silent = true }

    keymap.set("n", "[c", "<Plug>(coc-diagnostic-prev)", opts)
    keymap.set("n", "]c", "<Plug>(coc-diagnostic-next)", opts)
    keymap.set("n", "gd", "<Plug>(coc-definition)", opts)
    keymap.set("n", "gy", "<Plug>(coc-type-definition)", opts)
    keymap.set("n", "gi", "<Plug>(coc-implementation)", opts)
    keymap.set("n", "gr", "<Plug>(coc-references)", opts)
    keymap.set("n", "U", ":call <SID>show_documentation()<CR>", opts)
    keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", opts)
    keymap.set("v", "<leader>f", "<Plug>(coc-format-selected)", opts)
    keymap.set("n", "<leader>f", "<Plug>(coc-format-selected)", opts)

    -- CoC lists
    keymap.set("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
    keymap.set("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
    keymap.set("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
    keymap.set("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
    keymap.set("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
    keymap.set("n", "<space>j", ":<C-u>CocNext<CR>", opts)
    keymap.set("n", "<space>k", ":<C-u>CocPrev<CR>", opts)
    keymap.set("n", "<space>p", ":<C-u>CocListResume<CR>", opts)

    -- CoC tab completion
    function _G.check_back_space()
      local col = vim.fn.col('.') - 1
      return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
    end

    keymap.set("i", "<TAB>", function()
      if vim.fn.pumvisible() == 1 then
        return "<C-n>"
      elseif _G.check_back_space() then
        return "<TAB>"
      else
        return vim.fn['coc#refresh']()
      end
    end, { expr = true, silent = true })

    keymap.set("i", "<S-TAB>", function()
      return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-h>"
    end, { expr = true })

    keymap.set("i", "<c-space>", "coc#refresh()", { expr = true, silent = true })
  end
}