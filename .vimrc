"Plugins
call plug#begin('~/.vim/plugged')
Plug 'tidalcycles/vim-tidal'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'pangloss/vim-javascript'
"Plug 'maxmellon/vim-jsx-pretty'
Plug 'sheerun/vim-polyglot'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'
Plug 'ap/vim-css-color'
call plug#end()

"vim settings
"syntax enable

"set relativenumber
set clipboard=unnamed

"window movement
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
imap jk <Esc>

set encoding=UTF-8
set mouse=a
set shiftwidth=4
set tabstop=4
set autoindent
set number
"syntax on

set background=light

"colorscheme molokai_dark
"colorscheme molokai
"colorscheme valloric
"colorscheme lanox
colorscheme lanox_custom 
"colorscheme goldenrod 
"colorscheme monokai-phoenix  

let g:airline_powerline_fonts = 1

"NERDTree settings
map <C-n> :NERDTreeToggle<CR>
autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"Airline settings
let g:airline_solarized_bg='dark'
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
