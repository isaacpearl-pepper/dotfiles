return {
  "junegunn/fzf.vim",
  dependencies = { "junegunn/fzf" },
  config = function()
    -- FZF key mappings
    vim.keymap.set("n", "<C-p>", ":FZF<CR>", { noremap = true })
    vim.keymap.set("n", "<C-b>", ":Buffers<CR>", { noremap = true })
  end
}