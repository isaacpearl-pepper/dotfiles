return {
  "mileszs/ack.vim",
  config = function()
    -- Ack settings
    vim.g.ackprg = 'ag --nogroup --nocolor --column'

    -- Key mapping
    vim.keymap.set("n", "<C-k>", ":Ack<CR>", { noremap = true })
  end
}