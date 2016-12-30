set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin        'gmarik/Vundle.vim'

Plugin       'mileszs/ack.vim'
Plugin   'skywind3000/asyncrun.vim'
"Plugin     'lilydjwg/colorizer'
Plugin   'vim-scripts/dbext.vim'
Plugin          'mh21/errormarker.vim'
Plugin       'flugsio/fzf.vim'
"Plugin   'gregsexton/gitv'
Plugin       'morhetz/gruvbox'
"Plugin  'vim-scripts/lojban'
"Plugin         'tyru/open-browser.vim'
"Plugin         'kien/rainbow_parentheses.vim'
Plugin     'godlygeek/tabular'
"Plugin   'xaviershay/tslime.vim'
Plugin        'SirVer/ultisnips'
Plugin         'honza/vim-snippets'
Plugin         'chase/vim-ansible-yaml'
"Plugin        'tpope/vim-abolish'
Plugin        'kchmck/vim-coffee-script'
Plugin   'AndrewRadev/vim-eco' " requires vim-coffee-script
Plugin     'rust-lang/rust.vim'
Plugin    'racer-rust/vim-racer'
Plugin  'toyamarinyon/vim-swift'
Plugin         'tpope/vim-commentary'
Plugin         'tpope/vim-endwise'
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
"Plugin        'tpope/vim-sleuth' " 100ms
Plugin         'tpope/vim-surround'
Plugin       'cespare/vim-toml'
"Plugin         'kana/vim-vspec'
Plugin       'flugsio/Vomodoro'
Plugin       'flugsio/workflowish'
"Plugin     'Valloric/YouCompleteMe'

call vundle#end()

if &t_Co > 2
  syntax on
endif

if has("autocmd")
  filetype plugin indent on
  augroup vimrcEx
    autocmd!
    " cd to current directory, removes absolute part of filename
    autocmd BufRead * exec 'cd'.getcwd()
    autocmd FileType text setlocal textwidth=78
    autocmd! BufRead pomodoros.wofl call SetupPomodoroBuffer()
    autocmd! BufReadPost quickfix nnoremap <silent> <buffer> q :q<cr>
    autocmd! BufNewFile,BufRead *.ejs set ft=html | call matchadd("Search2", "<%-") | call matchadd("Search3", "<%=") 
    autocmd! User AsyncRunStart hi StatusLine ctermbg=232
    autocmd! User AsyncRunStop call AsyncStopCallback()
  augroup END
else
  set autoindent
endif

set shortmess+=I
set backspace=indent,eol,start
set noswapfile
set nobackup
set nowritebackup
set history=200
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
set belloff=esc
set laststatus=2
set ignorecase
set smartcase
set hlsearch
set splitright
set splitbelow
set formatoptions=qlj
set sessionoptions-=options
set clipboard=""
set guioptions=ec
set fillchars=vert:\ ,fold:-
set listchars=tab:>-,trail:·,eol:$
set nrformats-=octal
set signcolumn=no

set background=dark
set t_Co=256
let g:gruvbox_italic=0
silent! colorscheme gruvbox
hi StatusLine ctermfg=208 ctermbg=234 cterm=NONE
hi StatusLineNC ctermfg=108 ctermbg=234 cterm=NONE
hi VertSplit ctermfg=108 ctermbg=234 cterm=NONE
hi TabLineFill ctermfg=243 ctermbg=234 cterm=NONE
hi TabLineSel ctermfg=108 ctermbg=235 cterm=NONE

highlight Search2 ctermbg=blue ctermfg=black
highlight Search3 ctermbg=red ctermfg=black

" Plugin configs

let g:ansible_options = {'ignore_blank_lines': 0}
", 'documentation_mapping': '<C-K>'}

" glue between asyncrun and errormarker
let g:asyncrun_auto = "make"

let g:colorizer_nomap = 1
let g:colorizer_startup = 0

let g:ragtag_global_maps = 1

let g:UltiSnipsExpandTrigger="<c-i>"
let g:UltiSnipsEditSplit="vertical"

"set wildmenu
set wildmode=list:longest
set wildignore+=*.jpg,*.bmp,*.gif
set wildignore+=coverage
set wildignore+=*~

let g:racer_cmd="racer"
let $RUST_SRC_PATH="/usr/src/rust/src"

" pomodoros / glue for Vomodoro to bin/p
let g:Pomo_ArchiveFilePath = "~/code/sparkleshare/pomodoros_archive.wofl"
let g:Pomo_MinWindowHeight = 10

" open-browser.vim
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" jasmine
set errorformat+=%E\ %#Stack:,%C\ %#\ at\ %[%^(]%#\ (%f:%l:%c),%C\ %#%[%^:]%#:\ %m

" Abbreviations
iab <expr> dts strftime("%Y-%m-%d")
iab <expr> dta strftime("%Y-%m-%d %H:%M")
iab <expr> dtz strftime("%Y-%m-%dT%H:%M:%S%z")

" Mappings

let mapleader = ","
let maplocalleader = ";"

" Create undo-points when using Return and delete-to-beginning
inoremap <CR> <C-G>u<CR>
inoremap <C-U> <C-G>u<C-U>

" General
nnoremap <leader>q :quit<CR>
nnoremap <leader>te :UltiSnipsEdit<CR>

cmap w!! w !sudo tee % >/dev/null
nnoremap <C-s> :w<cr>

map Q qq
nnoremap <space> /
" v<space> (in visual mode, C-U removes selection)
xnoremap <silent> <space> :<C-U>cclose<bar>:nohlsearch<C-R>=has('diff')?'<bar>diffupdate':''<cr><cr>
nnoremap <silent> <leader>s :set nolist!<CR>
nnoremap <leader>G zM:g/context/foldopen\|:noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" centers and opens fold at cursor when going to next/previous match
nnoremap n nzzzv
nnoremap N Nzzzv

" sort css blocks; like vi{:sort but doesn't mangle nested scss
nnoremap <leader>S ?{<CR>jV/[{}]<CR>k:sort<CR>:noh<CR>
"nnoremap <leader>v V`]

" Git
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v<CR>
nnoremap <leader>gC :Gcommit -v --amend<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>do :diffoff!<CR>:only<CR>

" Jobs
nnoremap ! :AsyncRun<space>
nnoremap <silent> <leader>` :copen<CR>
nnoremap <leader>i :call system("tmux split-window -hbp 24 \"ran " . expand('%:p:h') . " \"")
nnoremap <leader>I :call system("tmux split-window -hbp 24 \"ran\"")
nnoremap <leader>o :call system("tmux split-window \"tig\"")
nnoremap <leader>l :call system("surf_go " . g:url)
"nnoremap <leader>l :w\|call system("export surfwid=" . g:browser_id . " && surf_go " . g:url)
"nnoremap <leader>l :w\|:call system("xdotool windowactivate " . g:browser_id . " key 'ctrl+r'")
nnoremap <leader>l :silent w\|:exec "AsyncRun send_key_to 'ctrl+r' ".g:browser_id<CR>
nnoremap <leader>p :silent !xdg-open <C-R>=escape("<C-R><C-F>", "#?&;\|%")<CR><CR>
vnoremap <leader>p :w !curl -F 'f:1=<-' ix.io<CR>
nnoremap <silent> <leader>k :silent w\|:exec 'AsyncRun '.g:async_cmd<CR>
nmap <silent> <leader>K :let g:async_cmd='rs '.expand('%')<CR><leader>k

" Finders
nnoremap <leader><space> :Files<cr>
" this next one searches from symlinks (when dir is specified), could have a better keycombo
" added in vim/bundle/fzf.vim/autoload/fzf/vim.vim
nnoremap <leader>,<space> :Files .<cr>
nnoremap <leader>. :Tags<cr>
nnoremap <leader>j :GitFilesModified<cr>
nnoremap <leader>f :Ack <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>F :Ack<space>

" Rails
nnoremap <leader>r :R<cr>
nnoremap <leader>R :R<space>
nnoremap <leader>a :A<cr>
nnoremap <leader>A :AV<cr>
nnoremap <leader>c :Econtroller<cr>
nnoremap <leader>C :Econtroller<space>
nnoremap <leader>v :Eview<cr>
nnoremap <leader>V :Eview<space>
nnoremap <leader>b :Ehelper<cr>
nnoremap <leader>B :Ehelper<space>
nnoremap <leader>n :Elocale en<cr>
nnoremap <leader>m :Emodel<cr>
nnoremap <leader>M :Emodel<space>

nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

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

" ctrl+altgr+g
cno  <C-\>eDeleteTillSlash()<cr>

nnoremap <leader>sfe :call PasteDBExecSQLUnderCursor()<cr>
function! PasteDBExecSQLUnderCursor()
  DBSetOption use_result_buffer=0
  call append(line('.'), split(dbext#DB_execSql(dbext#DB_getQueryUnderCursor()), '\n'))
  DBSetOption use_result_buffer=1
endfunction

nnoremap <leader>e :call MyDBExecSQLUnderCursor()<cr>
function! MyDBExecSQLUnderCursor()
  let pos = getpos(".")
  ?^\(;\|$\)?,/;$/DBExecRangeSQL
  call setpos('.', pos)
endfunction

"nnoremap <leader>E :call MyDBExecSQLUnderCursorALL()<cr>
"function! MyDBExecSQLUnderCursorALL()
"  let pos = getpos(".")
"  ?^\(;\|$\)?,/;$/DBExecRangeSQL
"  call setpos('.', pos)
"endfunction

function! AsyncStopCallback()
  if 0 < len(filter(getqflist(), 'v:val.valid'))
    hi StatusLine ctermbg=234 ctermfg=1
  else
    hi StatusLine ctermbg=234 ctermfg=208
    cclose
  end
endfunction

function! SelectBrowser()
  let g:browser_id = systemlist("xdotool selectwindow 2> /dev/null")[0]
endfunction

function! SetupPomodoroBuffer()
  nnoremap <buffer> <silent> <CR> :call CopyToBelowFromWorkflowish()<cr>
  "nnoremap <buffer> <silent> <Tab> :PomodoroToDoToday<cr>
  :PomodoroToDoToday
endfunction

" TODO: used from flugsio/Vomodoro wip branch
function! SendToPomo()
  let text = substitute(getline(line(".")), " \?\([[(]\(X| )[])]\).*", "", "")
  call system("~/bin/p -", text)
endfunction

function! CopyToBelowFromWorkflowish()
  let breadtrace = ""
  let lastindent = indent(line("."))+1
  for line in range(line("."), 1, -1)
    if l:lastindent > indent(line)
      let breadtrace = s:CleanLineForBreadcrumbCopy(line) . " > " . l:breadtrace
      let l:lastindent = indent(line)
    else
      break
    end
  endfor
  let breadtrace = substitute(l:breadtrace, " > $", "", "")
  if l:breadtrace == ""
    let breadtrace = "Root"
  endif
  normal! jG
  put =l:breadtrace
  normal! kj"
  return l:breadtrace
endfunction

function! s:CleanLineForBreadcrumbCopy(lnum)
  return substitute(substitute(getline(a:lnum), "\\v^( *)(\\\\|\\*|\\-) ", "", ""), " *$", "", "")
endfunction

function! DeleteTillSlash()
  let g:cmd = getcmdline()
  " delete tail back to last /
  let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  " for when last char is /, delete it too
  if g:cmd == g:cmd_edited
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
  endif
  return g:cmd_edited
endfunction

function! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunction

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

