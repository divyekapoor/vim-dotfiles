" -------- Vundle installation
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Configure vundles.
Bundle 'gmarik/vundle'
Bundle 'Valloric/YouCompleteMe'
Bundle 'Syntastic'
Bundle 'SingleCompile'

" Required by Vundle.
filetype plugin indent on
" --------- End Vundle install.

syntax on

" Configure YCM
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0

com! -bang W :w<bang>
com! -bang Q :q<bang>
com! -bang Wq :wq<bang>
com! -bang P :set paste!
nmap qq :qa<cr>

" Set a command line abbreviation such that %% expands to the directory of the
" current file. Source:
" http://vim.wikia.com/wiki/Easy_edit_of_files_in_the_same_directory
cabbr <expr> %% expand('%:p:h')

" Set environment options.
set autochdir
set autoindent
set backspace=indent,eol,start
set background=light
set expandtab
set foldmethod=indent
set hlsearch
set incsearch
set laststatus=2
set nofoldenable
set nosmartindent
set number
set ruler
set shiftwidth=2
set smartcase
set smarttab
set softtabstop=2
set statusline=%t%m%r%h%w\ (%{&ff}){%Y}[%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set tabstop=2
set wildmenu
set wildmode=longest:full,full

" Keyboard shortcuts for working with buffers.
nmap ,n :bnext<CR>
nmap ,p :bprev<CR>
nmap ,b :ls<CR>
nmap ,, :bnext<CR>
nmap ,d :bd<CR>
nmap ,r :SCCompileRun<cr>
nmap ,c :SCCompile<cr>

" Map qq to qa to quit all windows.
cmap qq qa

" Make C-h delete the last word.
imap <C-h> <C-w>

" keyboard shortcuts for indent, de-indent in all modes.
nmap <Tab> a<C-t><Esc>
nmap <S-Tab> a<C-d><Esc>
imap <C-Tab> <C-t>
imap <S-Tab> <C-d>
vmap <Tab> :><CR>gv
vmap <S-Tab> :<<CR>gv

" Map kj to Esc to swich modes quickly.
inoremap kj <ESC>

" Map Space and Backspace for fast vertical navigation.
nmap <Space> <C-d>
nmap = <C-d>
nmap <C-Space> <C-u>
nmap <BS> <C-u>

" Map hh and ll for super fast word navigation.
nmap hh B
nmap ll E

function! StripTrailingWhite()
  let l:winview = winsaveview()
  silent! %s/\s\+$//
  call winrestview(l:winview)
endfunction

" Strip trailing whitespace on write.
autocmd BufWritePre * call StripTrailingWhite()

" Highlight over length lines
highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
match OverLength /\%>80v.\+/

" Make C-S save the file always. Requires $ stty -ixon -ixoff as part of your
" terminal configuration. Also exit insert mode if you're in it.
nnoremap <C-S> :update<CR>
inoremap <C-S> <C-O>:update<CR><ESC>
vnoremap <C-S> <C-C>:update<CR>

" Line motion commands. Pretty useful when writing code.
function! MoveLineUp()
  call MoveLineOrVisualUp(".", "")
endfunction

function! MoveLineDown()
  call MoveLineOrVisualDown(".", "")
endfunction

function! MoveVisualUp()
  call MoveLineOrVisualUp("'<", "'<,'>")
  normal gv
endfunction

function! MoveVisualDown()
  call MoveLineOrVisualDown("'>", "'<,'>")
  normal gv
endfunction

function! MoveLineOrVisualUp(line_getter, range)
  let l_num = line(a:line_getter)
  if l_num - v:count1 - 1 < 0
    let move_arg = "0"
  else
    let move_arg = a:line_getter." -".(v:count1 + 1)
  endif
  call MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction

function! MoveLineOrVisualDown(line_getter, range)
  let l_num = line(a:line_getter)
  if l_num + v:count1 > line("$")
    let move_arg = "$"
  else
    let move_arg = a:line_getter." +".v:count1
  endif
  call MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction

function! MoveLineOrVisualUpOrDown(move_arg)
  let col_num = virtcol(".")
  execute "silent! ".a:move_arg
  execute "normal! ".col_num."|"
endfunction

nnoremap <silent> <C-k> :<C-u>call MoveLineUp()<CR>
nnoremap <silent> <C-j> :<C-u>call MoveLineDown()<CR>
inoremap <silent> <C-k> <C-o>:call MoveLineUp()<CR>
inoremap <silent> <C-j> <C-o>:call MoveLineDown()<CR>
vnoremap <silent> <C-k> :<C-u>call MoveVisualUp()<CR>
vnoremap <silent> <C-j> :<C-u>call MoveVisualDown()<CR>
xnoremap <silent> <C-k> :<C-u>call MoveVisualUp()<CR>
xnoremap <silent> <C-j> :<C-u>call MoveVisualDown()<CR>

" Jump to last known position in file. See :help line for details.
:au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif


" Set path for gf.
set path+=.
set path+=../
set path+=../../
set path+=../../../
set path+=../../../../
set path+=../../../../../
set path+=../../../../../../
set path+=../../../../../../../
