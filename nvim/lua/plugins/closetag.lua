return {
  "alvan/vim-closetag",
  ft = { "html", "xhtml", "phtml", "js", "jsx", "tsx" },
  config = function()
    -- Closetag settings
    vim.g.closetag_filenames = '*.html,*.xhtml,*.phtml,*.js'
    vim.g.closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'
    vim.g.closetag_filetypes = 'html,xhtml,phtml,js'
    vim.g.closetag_xhtml_filetypes = 'xhtml,jsx,js'
    vim.g.closetag_emptyTags_caseSensitive = 1
    vim.g.closetag_regions = {
      ['typescript.tsx'] = 'jsxRegion,tsxRegion',
      ['javascript.jsx'] = 'jsxRegion',
    }
    vim.g.closetag_shortcut = '>'
    vim.g.closetag_close_shortcut = '<leader>>'
  end
}