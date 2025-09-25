return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- Custom mapping for vertical split
        vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
      end,
    }

    -- Set custom highlight groups to match NERDTree colors from lanox_custom theme
    vim.api.nvim_set_hl(0, "NvimTreeNormal", { fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#949494" })
    vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = "#346EEB" })
    vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#949494" })
    vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = "#FFD700" })
    vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#949494" })
    vim.api.nvim_set_hl(0, "NvimTreeFileIcon", { fg = "#ffffff" })

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        require("nvim-tree.api").tree.open()
      end,
    })
  end,
}
