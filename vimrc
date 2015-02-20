" Plugins {{{1
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" Type next row ON third row to run it (sorts and aligns by plugin name)
" "qy$@q
" }jvip!sort -k2 -t/:Tabularize /'.*\/gv:s/\v(Plugin +)('.*\/)( +)/\1\3\2
" next paragraph next line visual inside paragraph command sort by second field separated by /
" tabularize around user name
" replace/move the space between username/repo to between Plugin/username

Plugin       'mileszs/ack.vim'
"Plugin        'spf13/asciidoc-vim'
Plugin      'lilydjwg/colorizer'
Plugin          'kien/ctrlp.vim'
Plugin   'vim-scripts/dbext.vim'
"Plugin   'gregsexton/gitv'
Plugin       'morhetz/gruvbox'
"Plugin  'vim-scripts/lojban'
"Plugin         'tyru/open-browser.vim'
"Plugin       'tomtom/quickfixsigns_vim'
"Plugin         'kien/rainbow_parentheses.vim'
Plugin     'godlygeek/tabular'
"Plugin       'tomtom/tlib_vim'
"Plugin       'tomtom/tmru_vim'
"Plugin       'tomtom/trag_vim'
"Plugin   'xaviershay/tslime.vim'
"Plugin  'vim-scripts/UltiSnips'
"Plugin       'tomtom/vikitasks_vim'
"Plugin       'tomtom/viki_vim'
"Plugin        'tpope/vim-abolish'
"Plugin        'tpope/vim-afterimage'
"Plugin       'kchmck/vim-coffee-script'
Plugin   'altercation/vim-colors-solarized'
"Plugin        'tpope/vim-commentary'
"Plugin        'tpope/vim-cucumber'
"Plugin     'Lokaltog/vim-easymotion'
"Plugin        'tpope/vim-endwise'
"Plugin         'int3/vim-extradite'
"Plugin        'tpope/vim-flatfoot'
Plugin         'tpope/vim-fugitive'
Plugin         'tpope/vim-git'
"Plugin        'tpope/vim-haml'
"Plugin     'Lokaltog/vim-powerline'
Plugin         'tpope/vim-ragtag'
Plugin         'tpope/vim-rails'
"Plugin        'tpope/vim-repeat'
Plugin    'derekwyatt/vim-scala'
Plugin         'tpope/vim-sleuth'
Plugin         'tpope/vim-surround'
"Plugin         'kana/vim-vspec'
Plugin       'flugsio/Vomodoro'
Plugin       'flugsio/workflowish'
"Plugin     'Valloric/YouCompleteMe'

call vundle#end()
" }}}1

" some stuff from http://amix.dk/vim/vimrc.html

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
set t_kb=

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

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

    autocmd! BufRead,BufNewFile *.viki set filetype=viki
    :au FocusLost * silent! wa " autosave
  augroup END

  let g:vikiNameSuffix=".viki"
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

set number
set sts=2
set sw=2

let g:colorizer_nomap = 1
let g:colorizer_startup = 0

let g:ragtag_global_maps = 1

nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_GainFocus_On_ToggleOpen=1

noremap <m-r> :TRecentlyUsedFiles<cr> 

" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
set encoding=utf-8
set scrolloff=2
"set autoindent
set hidden
set autoread
"set wildmenu
set wildmode=list:longest
set wildignore+=*.jpg,*.bmp,*.gif
set wildignore+=coverage
set wildignore+=*~
"set visualbell
"set ttyfast
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
set incsearch
set showmatch

set splitright
set splitbelow

nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

"set wrap
"set textwidth=79
"set formatoptions=qrn1
"set colorcolumn=85

" open-browser.vim
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" sort inside brackets, for css
"nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>
nnoremap <leader>S ?{<CR>jV/^\s*\}\?$<CR>k:sort<CR>:noh<CR>
"nnoremap <leader>v V`]

set guioptions=ec

set background=dark
set t_Co=256
let g:gruvbox_italic=0
silent! colorscheme gruvbox

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


" Abbreviations
iab <expr> dts strftime("%Y-%m-%d")
iab <expr> dtts strftime("%Y-%m-%d %H:%M")

" Centers and opens fold at cursor when going to next/previous match
nnoremap n nzzzv
nnoremap N Nzzzv

" leaders Q

nnoremap <leader>sef :call PasteDBExecSQLUnderCursor()<cr>
function! PasteDBExecSQLUnderCursor()
  DBSetOption use_result_buffer=0
  call append(line('.'), split(dbext#DB_execSql(dbext#DB_getQueryUnderCursor()), '\n'))
  DBSetOption use_result_buffer=1
endfunction

nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v<CR>
nnoremap <leader>gC :Gcommit -v --amend<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gb :Gblame<CR>

nnoremap <leader>db :vertical diffsplit ../ereg_byn/%:.<CR>
nnoremap <leader>dv :vertical diffsplit ../ereg_vvs/%:.<CR>
nnoremap <leader>do :diffoff!<CR>:only<CR>

"nnoremap <leader>k :w\|:call Send_to_Tmux("rspec\n")
"nnoremap <leader>k :w\|:call system("tmux send-keys -t:1 C-p C-m")
"nnoremap <leader>k :w\|:call system("tmux send-keys -t.+ C-p C-m")
"nnoremap <leader>k :w\|:call system("tmux send-keys -t%7 C-p C-m")
nnoremap <leader>p :silent !xdg-open <C-R>=escape("<C-R><C-F>", "#?&;\|%")<CR><CR>
vnoremap <leader>p :w !curl -F 'f:1=<-' ix.io<CR>

nnoremap <leader>k :w\|:call system("send_key_to 'ctrl+r' " . g:browser_id)

function! SelectBrowser()
  let g:browser_id = system("xdotool selectwindow 2> /dev/null")
endfunction

" ctrlp
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/](target|build|node_modules|public\/compiled|public\/piece)$',
      \ 'file': '\v\.(rlib|exe|so|dll)$',
      \ }
let g:ctrlp_map = '<leader>t'
nnoremap <leader>. :CtrlPTag<cr>
nnoremap <leader>: :!ctags -R .<cr>

" split vertically and move focus there
nnoremap <leader>w <C-w>v<C-w>l

" Rails
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

" pomodoros / glue for Vomodoro to bin/p
let g:Pomo_ArchiveFilePath = "~/code/sparkleshare/pomodoros_archive.wofl"
let g:Pomo_MinWindowHeight = 10
augroup PomodoroAUGroup
  autocmd! BufRead pomodoros.wofl call SetupPomodoroBuffer()
augroup END

function! SetupPomodoroBuffer()
  :PomodoroToDoToday
endfunction

" TODO: used from flugsio/Vomodoro wip branch
function! SendToPomo()
  let text = substitute(getline(line(".")), " \?\([[(]\(X| )[])]\).*", "", "")
  call system("~/bin/p -", text)
endfunction

cmap w!! w !sudo tee % >/dev/null


nnoremap <silent> <C-h> :call MoveToWindowOrTmux("h", "L")<cr>
nnoremap <silent> <C-j> :call MoveToWindowOrTmux("j", "D")<cr>
nnoremap <silent> <C-k> :call MoveToWindowOrTmux("k", "U")<cr>
nnoremap <silent> <C-l> :call MoveToWindowOrTmux("l", "R")<cr>

" if window stays the same, send key to tmux
function! MoveToWindowOrTmux(key, tmux_key)
  let l:last_winnr = winnr()
  execute "wincmd" a:key
  if l:last_winnr == winnr()
    execute "silent !tmux select-pane -".a:tmux_key
    redraw!
  endif
endfunction

vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

map § $
imap § $
vmap § $
cmap § $
nnoremap ö :
nnoremap Ö :
nnoremap ä ]`
nnoremap Ä [`
nnoremap <C-p> :cprevious<CR>
nnoremap <C-n> :cnext<CR>
nnoremap å `


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
nnoremap <leader>f :Ack <c-r>=expand("<cword>")<CR><CR>

"set colorcolumn=85
" flyttad till railscasts 
" highlight ColorColumn guibg=#333333

" dbext execute line and paste result buffer indended on next line
" almost the same as PasteDBExecSQLUnderCursor, slighly slower
" let @r=",sel ggjj\"yYjjVGk\"Yyp`[`]0I  k"


"compiler rspec
"nmap <Leader>fd :cf /tmp/autotest.txt<cr> :compiler rspec<cr>

" Indentation with tab {{{1
"" Tab: Add one level of indent to selected lines.
"
"xmap <Tab> >0gv
"smap <Tab> <C-O>V<C-O><Tab>
"
"" Shift-Tab: Remove one level of indent from selected lines.
"
"xmap <S-Tab> <0gv
"smap <S-Tab> <C-O>V<C-O><S-Tab>
"
"" Tab: Start keyword completion after keyword characters.
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
" }}}1

" This allows for change paste motion cp{motion}
" for example cpw replaces word with pastebuffer while keeping buffer intact
" http://stackoverflow.com/a/5357194
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
    silent exe "normal! `[v`]\"_c"
    silent exe "normal! p"
endfunction

