return {
  "fatih/vim-go",
  config = function()
    -- vim-go settings
    vim.g.go_highlight_types = 1
    vim.g.go_highlight_function_calls = 1
    vim.g.go_highlight_fields = 1
    vim.g.go_highlight_structs = 1
    vim.g.go_highlight_methods = 1
    vim.g.go_highlight_functions = 1
    vim.g.go_highlight_extra_types = 1
    vim.g.go_highlight_operators = 1
    vim.g.go_highlight_build_constraints = 1
    vim.g.go_fmt_command = 'gofmt'
    vim.g.go_highlight_diagnostic_errors = 1
    vim.g.go_highlight_diagnostic_warnings = 1
    vim.g.gotests_bin = '/Users/ipearl/go/bin/gotests'
  end
}
