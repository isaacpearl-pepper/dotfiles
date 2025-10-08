return {
  "github/copilot.vim",
  config = function()
    -- Set Node.js path for Copilot to use Node 24
    vim.g.copilot_node_command = "/Users/ipearl/.nvm/versions/node/v24.9.0/bin/node"
  end,
}