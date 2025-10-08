return {
  "vim-airline/vim-airline",
  dependencies = { "vim-airline/vim-airline-themes" },
  config = function()
    -- Airline settings
    vim.g.airline_solarized_bg = 'dark'
    vim.g.airline_powerline_fonts = 1
    vim.g['airline#extensions#whitespace#enabled'] = 0
    vim.g.airline_section_a = '%{airline#extensions#whitespace#check()}'
  end
}