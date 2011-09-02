filetype off
call pathogen#infect()

" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
colorscheme railscasts
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set noswapfile

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Fullskärm, cmd-shift-F för att toggla
"if has("gui_running")
"  set fuoptions=maxvert,maxhorz
"  au GUIEnter * set fullscreen
"endif

:au FocusLost * silent! wa " autosave

set number
"colorscheme railscasts
set background=dark
colorscheme solarized
set sts=2
set sw=2

nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_GainFocus_On_ToggleOpen=1

" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
set encoding=utf-8
set scrolloff=3
"set autoindent
"set showmode
"set showcmd
"set hidden
"set wildmenu
"set wildmode=list:longest
"set visualbell
set cursorline
"set ttyfast
"set ruler
"set backspace=indent,eol,start
set laststatus=2
"set relativenumber
"set undofile

let mapleader = ","

" för att få riktiga regexp
" nnoremap / /\v
" vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

set splitright
set splitbelow

nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

"set wrap
"set textwidth=79
"set formatoptions=qrn1
"set colorcolumn=85

"set list
"set listchars=tab:▸\ ,eol:¬

set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

"nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>
nnoremap <leader>S ?{<CR>jV/^\s*\}\?$<CR>k:sort<CR>:noh<CR>
"nnoremap <leader>v V`]

inoremap jj <ESC>

" har tagit bort r och T för typ right scrollbar och toolbar
set guioptions=egmt
set guifont=Menlo:h14
"set guifont=Inconsolata:h18

" leaders Q
nnoremap <leader>w <C-w>v<C-w>l

nnoremap <leader>e :RVview<cr>:RSview _form<cr><C-w>h:RSmodel<cr><C-w>k

nnoremap <leader>r :R<cr>
nnoremap <leader>R :R 
" leaders A
nnoremap <leader>a :A<cr>
nnoremap <leader>A :AV<cr>
" leaders Z
nnoremap <leader>z :Rstylesheet 
nnoremap <leader>Z :Rlayout 
nnoremap <leader>x :Rjavascript 
nnoremap <leader>X :Rlib 
nnoremap <leader>c :Rcontroller<cr>
nnoremap <leader>C :Rcontroller 
nnoremap <leader>v :Rview<cr>
nnoremap <leader>V :Rview 
nnoremap <leader>b :Rhelper<cr>
nnoremap <leader>B :Rhelper 
nnoremap <leader>n :Rlocale sv-SE<cr>
nnoremap <leader>N :Rmigration 
nnoremap <leader>m :Rmodel<cr>
nnoremap <leader>M :Rmodel 



nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

let g:CommandTMaxHeight = 15
noremap <leader>y :CommandTFlush<CR>

nnoremap ö /
nnoremap Ö ?
nnoremap ä ]`
nnoremap Ä [`
nnoremap - :cprevious<CR>
nnoremap + :cnext<CR>
nnoremap å `

"nnoremap <leader>a :Ack 
"nnoremap <leader>f :Ack <c-r>=expand("<cword>")<CR><CR>
"nnoremap <leader>d :Ack def\ <c-r>=expand("<cword>")<CR><CR>

nnoremap <F5> :GundoToggle<CR>

"set colorcolumn=85
" flyttad till railscasts 
" highlight ColorColumn guibg=#333333

set wildignore+=*.jpg,*.bmp,*.gif
set wildignore+=doc
set wildignore+=coverage

let @t='itry(:ea)'


compiler rspec
nmap <Leader>fd :cf /tmp/autotest.txt<cr> :compiler rspec<cr>


" Control-Shift-PageUp: Drag active tab page left. {{{2

imap <C-S-PageUp> <C-O>:TabMoveLeft<CR>
nmap <C-S-PageUp> :TabMoveLeft<CR>

command -bar TML call s:TabMoveLeft()
command -bar TabMoveLeft call s:TabMoveLeft()

function s:TabMoveLeft()
  let n = tabpagenr()
  execute 'tabmove' (n == 1 ? '' : n - 2)
  " Redraw tab page labels.
  let &showtabline = &showtabline
endfunction

" Control-Shift-PageDown: Drag active tab page right. {{{2

imap <C-S-PageDown> <C-O>:TabMoveRight<CR>
nmap <C-S-PageDown> :TabMoveRight<CR>

command -bar TMR call s:TabMoveRight()
command -bar TabMoveRight call s:TabMoveRight()

function s:TabMoveRight()
  let n = tabpagenr()
  execute 'tabmove' (n == tabpagenr('$') ? 0 : n)
  " Redraw tab pageitry(:ea) labels.
  let &showtabline = &showtabline
endfunction


"" Tab: Add one level of indent to selected lines. {{{2
"
"xmap <Tab> >0gv
"smap <Tab> <C-O>V<C-O><Tab>
"
"" Shift-Tab: Remove one level of indent from selected lines. {{{2
"
"xmap <S-Tab> <0gv
"smap <S-Tab> <C-O>V<C-O><S-Tab>
"
"" Tab: Start keyword completion after keyword characters. {{{2
"
"inoremap <expr> <Tab> <Sid>TabComplete()
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
"
"function s:TabComplete()
"  if pumvisible()
"    " In the pop-up menu <Tab> selects the next menu item.
"    return "\<C-n>"
"  elseif search('\k\%#', 'bcn', line('.')) && getline('.') !~ '\S\t\+\S'
"    " After keyword characters <Tab> starts keyword completion, except on
"    " lines with tab-delimited fields like /etc/fstab and /etc/crypttab.
"    return "\<C-n>"
"  else
"    " In all other cases, fall back to the default behavior.
"    return "\<Tab>"
"  endif
"endfunction

nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
    silent exe "normal! `[v`]\"_c"
    silent exe "normal! p"
endfunction

set wildmode=list:longest
