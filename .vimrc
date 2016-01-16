" -------- Vundle installation
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Configure vundles.
Plugin 'gmarik/vundle'
Plugin 'Syntastic'
Plugin 'SingleCompile'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'Solarized'
Plugin 'surround.vim'
Plugin 'bling/vim-bufferline'
Plugin 'vim-airline/vim-airline'

call vundle#end()

" Required by Vundle.
filetype plugin indent on
" --------- End Vundle install.

syntax on

" Configure YCM
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0

command! -bang W :w
command! -bang Q :q
command! -bang Wq :wq
nmap qq :qa<cr>

" Set a command line abbreviation such that %% expands to the directory of the
" current file. Source:
" http://vim.wikia.com/wiki/Easy_edit_of_files_in_the_same_directory
cabbr <expr> %% expand('%:p:h')

" Set environment options.
set autochdir
set autoindent
set backspace=indent,eol,start
set background=dark
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
nmap ,s :vsplit<CR>:bnext<CR>
nmap ,d :bd<CR>
nmap ,r :SCCompileRun<cr>
nmap ,c :SCCompile<cr>
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l

" Buffer motion between files.
function! MoveToFile(pattern, extension)
  let l:filename = expand("%:p")
  let l:subfilename = substitute(l:filename, a:pattern, a:extension, "")
  exe 'edit ' . l:subfilename
endfunction

function! MoveToCCFile()
  call MoveToFile('\(_test.cc\|.h\)$', ".cc")
endfunction

function! MoveToHFile()
  call MoveToFile('\(_test.cc\|.cc\)$', ".h")
endfunction

function! MoveToTestFile()
  call MoveToFile('\(.cc\|.h\)$', "_test.cc")
endfunction

nmap ,h :call MoveToHFile()<CR>
nmap ,t :call MoveToTestFile()<CR>
nmap ,c :call MoveToCCFile()<CR>

" CtrlP buffer switching by default.
let g:ctrlp_cmd = 'CtrlPBuffer'

" Netrw explorer.
" Edit in same window. Split vertically.
let g:netrw_winsize = 0
let g:netrw_chgwin = -1
nmap <C-m> :Vexplore<CR>

" Map qq to qa to quit all windows.
cmap qq qa
nmap qq :qa<CR>

" Make Vs map to vs for splitting windows.
cmap Vs vs

" Map E to edit (slow fingers!)
command! -nargs=* -bar -bang -count=0 -complete=file E edit <args>

" Make C-s save files. Requires stty -ixon -ixoff in your .bashrc.
imap <C-s> <ESC>:w<CR>
nmap <C-s> :w<CR>

" Make C-i toggle between insert and paste mode.
set pastetoggle=<C-i>

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

" Make for dark background. Solarized color scheme.
set background=dark
let g:solarized_termcolors = 256
let g:solarized_contrast = "high"
colorscheme solarized

" Clear the highlight after searching
nmap <silent> <C-c> :let @/ = ""<CR>

" Word motion
nmap l w
nmap h b

" Map 0 to logical beginning of the line.
" It's easier than ^
nmap 0 ^

" Jump to last edited location in the file.
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Configure statusline (use vim-airline)
let g:airline#extensions#bufferline#overwrite_variables = 1
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V',
    \ '' : 'V',
    \ 's'  : 'S',
    \ 'S'  : 'S',
    \ '' : 'S',
    \ }

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_theme = "distinguished"
let g:airline_detect_paste = 1
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'

let g:bufferline_echo = 0
function! AirlineInit()
  let g:airline_section_a = airline#section#create(['mode', ' ', '%l', ':', '%c'])
  let g:airline_section_c = '%{bufferline#refresh_status()}'.bufferline#get_status_string()
  let g:airline_section_z = airline#section#create(['%p', '%%'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()


" Set path for gf.
set path+=.
set path+=../
set path+=../../
set path+=../../../
set path+=../../../../
set path+=../../../../../
set path+=../../../../../../
set path+=../../../../../../../
