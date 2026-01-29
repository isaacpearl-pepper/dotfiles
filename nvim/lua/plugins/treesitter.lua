return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- Setup nvim-treesitter (adds queries to runtimepath)
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Enable treesitter highlighting for Python
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
