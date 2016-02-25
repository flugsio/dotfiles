" Plugins {{{1
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin       'mileszs/ack.vim'
"Plugin     'lilydjwg/colorizer'
Plugin          'kien/ctrlp.vim'
Plugin   'vim-scripts/dbext.vim'
"Plugin   'gregsexton/gitv'
Plugin       'morhetz/gruvbox'
"Plugin  'vim-scripts/lojban'
"Plugin         'tyru/open-browser.vim'
"Plugin         'kien/rainbow_parentheses.vim'
Plugin     'godlygeek/tabular'
"Plugin       'tomtom/tlib_vim'
"Plugin       'tomtom/tmru_vim'
"Plugin       'tomtom/trag_vim'
"Plugin   'xaviershay/tslime.vim'
Plugin        'SirVer/ultisnips'
Plugin         'honza/vim-snippets'
Plugin         'chase/vim-ansible-yaml'
"Plugin        'tpope/vim-abolish'
Plugin        'kchmck/vim-coffee-script'
Plugin   'AndrewRadev/vim-eco' " requires vim-coffee-script
Plugin     'rust-lang/rust.vim'
Plugin         'tpope/vim-commentary'
"Plugin        'tpope/vim-cucumber'
"Plugin     'Lokaltog/vim-easymotion'
"Plugin        'tpope/vim-endwise'
"Plugin         'int3/vim-extradite'
"Plugin        'tpope/vim-flatfoot'
Plugin         'tpope/vim-fugitive'
Plugin         'tpope/vim-git'
"Plugin        'tpope/vim-haml'
Plugin        'dzeban/vim-log-syntax'
Plugin         'tpope/vim-ragtag'
Plugin         'tpope/vim-rails'
Plugin    'thoughtbot/vim-rspec'
Plugin         'tpope/vim-repeat'
Plugin    'derekwyatt/vim-scala'
"Plugin         'tpope/vim-sleuth' " 100ms
Plugin         'tpope/vim-surround'
Plugin       'cespare/vim-toml'
"Plugin         'kana/vim-vspec'
Plugin       'flugsio/Vomodoro'
Plugin       'flugsio/workflowish'
"Plugin     'Valloric/YouCompleteMe'

call vundle#end()
" }}}1

if &t_Co > 2
  syntax on
endif

if has("autocmd")
  filetype plugin indent on
  augroup vimrcEx
    au!
    autocmd FileType text setlocal textwidth=78

    " Jump to the last known valid cursor position if not first line
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif
    autocmd! BufRead pomodoros.wofl call SetupPomodoroBuffer()
  augroup END
else
  set autoindent
endif

set backspace=indent,eol,start
set noswapfile
set nobackup
set nowritebackup
set history=50
set ruler
set showcmd
set incsearch
set softtabstop=2
set shiftwidth=2
set expandtab
set encoding=utf-8
set scrolloff=2
set hidden
set autoread
"set visualbell
"set ttyfast
set laststatus=2

set ignorecase
set smartcase
set hlsearch
set showmatch

set splitright
set splitbelow

set formatoptions=ql

"set guioptions=ec

set fillchars=vert:\ ,fold:-
set background=dark
set t_Co=256
let g:gruvbox_italic=0
silent! colorscheme gruvbox
hi StatusLine ctermfg=208 ctermbg=234 cterm=NONE
hi StatusLineNC ctermfg=108 ctermbg=234 cterm=NONE
hi VertSplit ctermfg=108 ctermbg=234 cterm=NONE
hi TabLineFill ctermfg=243 ctermbg=234 cterm=NONE
hi TabLineSel ctermfg=108 ctermbg=235 cterm=NONE 

" Plugin configs

let g:ansible_options = {'ignore_blank_lines': 0}
", 'documentation_mapping': '<C-K>'}

let g:colorizer_nomap = 1
let g:colorizer_startup = 0

let g:ragtag_global_maps = 1

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-i>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

"set wildmenu
set wildmode=list:longest
set wildignore+=*.jpg,*.bmp,*.gif
set wildignore+=coverage
set wildignore+=*~

" Mappings

let mapleader = ","
let maplocalleader = ";"

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

map Q qq
nnoremap <space> /
" v<space> (visual mode) to remove highlight and quickfix
xnoremap <silent> <space> :<C-U>noh\|:cclose<cr>
"nnoremap <leader>F
nnoremap <leader>G zM:g/context/foldopen\|:noh<cr>
nnoremap <tab> %
vnoremap <tab> %

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

" Abbreviations
iab <expr> dts strftime("%Y-%m-%d")
iab <expr> dta strftime("%Y-%m-%d %H:%M")
iab <expr> dtz strftime("%Y-%m-%dT%H:%M:%S%z")

" Centers and opens fold at cursor when going to next/previous match
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <leader>sef :call PasteDBExecSQLUnderCursor()<cr>
function! PasteDBExecSQLUnderCursor()
  DBSetOption use_result_buffer=0
  call append(line('.'), split(dbext#DB_execSql(dbext#DB_getQueryUnderCursor()), '\n'))
  DBSetOption use_result_buffer=1
endfunction

nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v<CR>
nnoremap <leader>gC :Gcommit -v --amend<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gb :Gblame<CR>

nnoremap <leader>do :diffoff!<CR>:only<CR>

nnoremap <leader>i :call system("tmux split-window \"EDITOR='tmux_editor' ranger\"")
nnoremap <leader>I :call system("tmux split-window \"EDITOR='tmux_editor' ranger %:p:h\"")
nnoremap <leader>o :call system("tmux split-window \"tig\"")
nnoremap <leader>l :call system("surf_go " . g:url")
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

" old mapping, no-operation for now
nnoremap <leader>t :noh<cr>
" ctrlp
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.pyc"
      \ -g ""'
let g:ctrlp_map = '<leader><space>'
let g:ctrlp_working_path_mode = 'ra'
nnoremap <leader>. :CtrlPTag<cr>
nnoremap <leader>: :!ctags -R .<cr>

" split vertically and move focus there
nnoremap <leader>w <C-w>v<C-w>l

" Rails
nnoremap <leader>e :RVview<cr>:RSview _form<cr><C-w>h:RSmodel<cr><C-w>k
nnoremap <leader>E :e doc/changes.txt<cr>:RVtask permissions<cr>:RVlocale sv-SE<cr><C-w>K:RVmigration 0<cr><C-w>h<C-w>10+

" this is a trick to not end a line with trailing whitespace <c-r>=<esc>
nnoremap <leader>r :R<cr>
nnoremap <leader>R :R <c-r>=<esc>
" leaders A
nnoremap <leader>a :A<cr>
nnoremap <leader>A :AV<cr>
" leaders Z
nnoremap <leader>z :Estylesheet <c-r>=<esc>
nnoremap <leader>Z :Elayout <c-r>=<esc>
nnoremap <leader>x :Ejavascript <c-r>=<esc>
nnoremap <leader>X :Elib <c-r>=<esc>
nnoremap <leader>c :Econtroller<cr>
nnoremap <leader>C :Econtroller <c-r>=<esc>
nnoremap <leader>v :Eview<cr>
nnoremap <leader>V :Eview <c-r>=<esc>
nnoremap <leader>b :Ehelper<cr>
nnoremap <leader>B :Ehelper <c-r>=<esc>
nnoremap <leader>n :Elocale sv-SE<cr>
nnoremap <leader>N :Emigration <c-r>=<esc>
nnoremap <leader>m :Emodel<cr>
nnoremap <leader>M :Emodel <c-r>=<esc>

" pomodoros / glue for Vomodoro to bin/p
let g:Pomo_ArchiveFilePath = "~/code/sparkleshare/pomodoros_archive.wofl"
let g:Pomo_MinWindowHeight = 10

function! SetupPomodoroBuffer()
  :PomodoroToDoToday
endfunction

" TODO: used from flugsio/Vomodoro wip branch
function! SendToPomo()
  let text = substitute(getline(line(".")), " \?\([[(]\(X| )[])]\).*", "", "")
  call system("~/bin/p -", text)
endfunction

cmap w!! w !sudo tee % >/dev/null

nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

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


" Parenthesis/bracket expanding
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
"vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>
vnoremap $t <esc>`>a><esc>`<i<<esc>

" Map auto complete of (, ", ', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $$ {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i
inoremap $t <><esc>i

" Difference between the current buffer and disk version
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" ctrl+altgr+g
cno  <C-\>eDeleteTillSlash()<cr>

func! DeleteTillSlash()
  let g:cmd = getcmdline()
  " delete tail back to last /
  let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  " for when last char is /, delete it too
  if g:cmd == g:cmd_edited
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
  endif
  return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunc

"nnoremap <leader>a :Ack <c-r>=<esc>
nnoremap <leader>f :Ack <c-r>=expand("<cword>")<CR><CR>

" dbext execute line and paste result buffer indended on next line
" almost the same as PasteDBExecSQLUnderCursor, slighly slower
" let @r=",sel ggjj\"yYjjVGk\"Yyp`[`]0I  k"

" This allows for change paste motion cp{motion}
" for example cpw replaces word with pastebuffer while keeping buffer intact
" http://stackoverflow.com/a/5357194
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
    silent exe "normal! `[v`]\"_c"
    silent exe "normal! p"
endfunction

