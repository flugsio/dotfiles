filetype off
call pathogen#infect()
"call pathogen#helptags()

" some stuff from http://amix.dk/vim/vimrc.html

set nocompatible
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set noswapfile

" MySys()
source ~/.vimrc_local

set nobackup
set nowritebackup
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
"if has('mouse')
"  set mouse=a
"endif

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

  let g:vikiNameSuffix=".viki"
  autocmd! BufRead,BufNewFile *.viki set filetype=viki
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
"augroup BgHighlight
"    autocmd!
"    autocmd WinEnter * set cursorcolumn
"    autocmd WinLeave * set nocursorcolumn
"augroup END
set sts=2
set sw=2

nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_GainFocus_On_ToggleOpen=1

noremap <m-r> :TRecentlyUsedFiles<cr> 

" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
set encoding=utf-8
set scrolloff=2
"set autoindent
"set showmode
"set showcmd
set hidden
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
let maplocalleader = ";"

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

set guioptions=e

set background=dark
if has("gui_running")
  colorscheme solarized
else
  colorscheme darkblue
endif

" Set font according to system
if MySys() == "mac"
  set guifont=Menlo:h14
  "set guifont=Ubuntu\ Mono:h16
  "set guifont=Inconsolata:h18
  set shell=/bin/bash
elseif MySys() == "windows"
  set  guifont=Bitstream\ Vera\ Sans\ Mono:h10
elseif MySys() == "linux"
  set guifont=Ubuntu\ Mono\ 12
  set shell=/bin/bash
endif

" leaders Q
nnoremap <leader>w <C-w>v<C-w>l

nnoremap <leader>e :RVview<cr>:RSview _form<cr><C-w>h:RSmodel<cr><C-w>k
nnoremap <leader>E :e doc/changes.txt<cr>:RVtask permissions<cr>:RVlocale sv-SE<cr><C-w>K:RVmigration 0<cr><C-w>h<C-w>10+

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

vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

let g:CommandTMaxHeight = 15
noremap <leader>y :CommandTFlush<CR>

map § $
imap § $
vmap § $
cmap § $
nnoremap ö :
nnoremap Ö ;
map <space> /
map <c-space> ?
"nnoremap - /
"nnoremap _ ?
nnoremap ä ]`
nnoremap Ä [`
nnoremap <C-p> :cprevious<CR>
nnoremap <C-n> :cnext<CR>
nnoremap å `
" disable arrow keys till i have learned
noremap  <Up> ""
noremap! <Up> <Esc>
noremap  <Down> ""
noremap! <Down> <Esc>
"noremap  <Left> ""
noremap! <Left> <Esc>
"noremap  <Right> ""
noremap! <Right> <Esc>
map <right> :bn<cr>
map <left> :bp<cr>

"tab mappings
map <D-1> 1gt
map <D-2> 2gt
map <D-3> 3gt
map <D-4> 4gt
map <D-5> 5gt
map <D-6> 6gt
map <D-7> 7gt
map <D-8> 8gt
map <D-9> 9gt
" these already exists in macvim
"map <D-t> :tabnew<CR>
"map <D-w> :tabclose<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>

" Map auto complete of (, ", ', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i
inoremap $t <><esc>i

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap VIM 0
map 0 ^

"Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if MySys() == "mac"
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif


cno $q <C-\>eDeleteTillSlash()<cr>

func! DeleteTillSlash()
  let g:cmd = getcmdline()
  if MySys() == "linux" || MySys() == "mac"
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  else
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
  endif
  if g:cmd == g:cmd_edited
    if MySys() == "linux" || MySys() == "mac"
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
    else
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
    endif
  endif
  return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunc

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
set wildignore+=*~

let @t='itry(:ea)'


compiler rspec
nmap <Leader>fd :cf /tmp/autotest.txt<cr> :compiler rspec<cr>


function! ToggleShowTabLine()
  if &showtabline != 0
    set showtabline=0
  else
    set showtabline=2
  end
endfunction
"map <silent> <F12> :call ToggleShowTabLine()<cr>

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
