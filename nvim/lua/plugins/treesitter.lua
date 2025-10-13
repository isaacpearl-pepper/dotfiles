return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "python",
        "go",
        "javascript",
        "typescript",
        "lua",
        "vim",
        "vimdoc",
        "c",
        "cpp",
        "bash",
        "json",
        "yaml",
        "html",
        "css",
        "graphql",
        "sql",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    })
  end,
}
