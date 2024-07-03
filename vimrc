set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin        'gmarik/Vundle.vim'

" these case issues with escape
" it jumps toggles into insert mode
" Plugin 'prabirshrestha/async.vim'
" Plugin 'prabirshrestha/vim-lsp'
" Plugin 'prabirshrestha/asyncomplete.vim'
" Plugin 'prabirshrestha/asyncomplete-lsp.vim'

Plugin   'majutsushi/tagbar'
Plugin       'mileszs/ack.vim'
" TODO: this repo is bork, either set transfer.fsckobjects = false or --depth 1
Plugin   'skywind3000/asyncrun.vim'
"Plugin     'lilydjwg/colorizer'
Plugin   'vim-scripts/dbext.vim'
Plugin          'mh21/errormarker.vim'
Plugin       'ElmCast/elm-vim'
Plugin       'flugsio/fzf.vim'
"Plugin   'gregsexton/gitv'
Plugin       'morhetz/gruvbox'
"Plugin  'vim-scripts/lojban'
"Plugin         'tyru/open-browser.vim'
"Plugin         'kien/rainbow_parentheses.vim'
Plugin     'godlygeek/tabular'
"Plugin   'xaviershay/tslime.vim'
Plugin   'leafgarland/typescript-vim'
Plugin        'quramy/tsuquyomi'
Plugin        'Quramy/vim-js-pretty-template'
Plugin     'jason0x43/vim-js-indent'
if has('python3')
  Plugin      'SirVer/ultisnips'
endif
if has('python3')
  " TODO: find/configure debugging plugin
  Plugin        'joonty/vdebug'
endif
Plugin         'honza/vim-snippets'
Plugin         'chase/vim-ansible-yaml'
"Plugin        'tpope/vim-abolish'
Plugin        'kchmck/vim-coffee-script'
Plugin   'AndrewRadev/vim-eco' " requires vim-coffee-script
Plugin  'rainerborene/vim-reek'
Plugin     'rust-lang/rust.vim'
Plugin    'racer-rust/vim-racer'
Plugin          'ngmy/vim-rubocop'
Plugin  'toyamarinyon/vim-swift'
Plugin         'tpope/vim-commentary'
Plugin         'tpope/vim-endwise'
"Plugin         'int3/vim-extradite'
"Plugin        'tpope/vim-flatfoot'
Plugin         'tpope/vim-fugitive'
Plugin         'tpope/vim-rhubarb'
Plugin         'tpope/vim-git'
"Plugin        'tpope/vim-haml'
Plugin        'dzeban/vim-log-syntax'
Plugin         'tpope/vim-ragtag'
Plugin         'tpope/vim-rake'
Plugin         'tpope/vim-projectionist'
Plugin         'tpope/vim-bundler'
Plugin         'tpope/vim-rails'
Plugin      'vim-ruby/vim-ruby'
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
if has('nvim')
  Plugin     'francoiscabrol/ranger.vim'
end
Plugin  'puremourning/vimspector'

call vundle#end()

if &t_Co > 2
  syntax on
endif

let g:pairing=filereadable($HOME.'/.cache/pairing')
"let g:pairing=0

if has("gui_gtk3")
  set guifont=Ubuntu\ Mono\ 20
  set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver20-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkwait400-blinkoff500-blinkon500
end

" set cursor insert in insert mode
" works in alacritty/tmux, kitty, and st
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

if has("autocmd")
  filetype plugin indent on
  augroup vimrcEx
    autocmd!
    " cd to current directory, removes absolute part of filename
    autocmd BufRead * exec 'cd '.fnameescape(getcwd())
    " workaround broken diff with fugitive
    " reproduce: open vim with ':set hidden', in the [No name] buffer run :Gdiff, :close, :Gstatus, dv (open new diff)
    autocmd BufHidden * set nodiff 
    autocmd FileType text setlocal textwidth=78
    autocmd BufEnter .git/COMMIT_EDITMSG nnoremap <buffer> <silent> <leader>gc :call GivePairingCredit()<cr>
    "autocmd FileType rust compiler cargo
    "autocmd FileType rust setl makeprg=cargo\ build
    autocmd! BufRead *.wofl call SetupWoflToPomodoroBuffer()
    autocmd! BufRead *.asm set noet sw=8
    autocmd! BufReadPost *.md let g:async_command = ':Tabularize /|/'
    autocmd! FileType ansible.yaml syn match Secrets /.*\(pass\|secret\).*: \S\+$/ conceal cchar=¤
    autocmd! FileType ansible.yaml set conceallevel=2
    autocmd! BufReadPost quickfix nnoremap <silent> <buffer> q :q<cr>
    autocmd! BufNewFile,BufRead *.ejs set ft=html | call matchadd("Search2", "<%-") | call matchadd("Search3", "<%=") 
    autocmd! User AsyncRunStart hi StatusLine ctermbg=232
    autocmd! User AsyncRunStop call AsyncStopCallback()
    "autocmd! FileType rust nmap gd <Plug>(rust-def)
    "autocmd! FileType rust nmap <leader>gi <Plug>(rust-doc)
    if g:pairing
      set number
      set cursorline
      autocmd WinEnter * set number | set cursorline
      autocmd WinLeave * set nocursorline
    else
      set nonumber
      set nocursorline
      " TODO: set in all open windows instead
      autocmd WinEnter * set nonumber | set nocursorline
    endif

    "autocmd FileType ruby setlocal suffixesadd+=.rb
    "autocmd FileType ruby setlocal path+=~/appraisal/lib
  augroup END
else
  set autoindent
endif

set shortmess+=I
set backspace=indent,eol,start
set noswapfile
set nobackup
set nowritebackup
set history=1000
set ruler
set showcmd
set incsearch
set softtabstop=2
set shiftwidth=2
set expandtab
set encoding=utf-8
set scrolloff=2
set sidescrolloff=5
set hidden
set autoread
silent! set belloff=esc
set laststatus=2
set ignorecase
set smartcase
" Don't set again when reloading configuration
" Otherwise the state of showing highlighs might change
if &hlsearch == 0
  set hlsearch
end
set splitright
set splitbelow
set formatoptions=qlj
set sessionoptions-=options
set clipboard=""
set guioptions=ec
set fillchars=vert:\ ,fold:-
set listchars=tab:>-,trail:·,eol:$
set nrformats-=octal
silent! set signcolumn=no
set colorcolumn=80,100

"if 5 < strftime("%H") && strftime("%H") < 13
"  set background=light
"else
"  set background=dark
"endif
set background=dark
set t_Co=256
let g:gruvbox_italic=0
let g:gruvbox_termcolors=16
silent! colorscheme gruvbox
if &background == "dark"
  hi StatusLine ctermfg=208 ctermbg=234 cterm=NONE
  hi StatusLineNC ctermfg=108 ctermbg=234 cterm=NONE
  hi VertSplit ctermfg=108 ctermbg=234 cterm=NONE
  hi TabLineFill ctermfg=243 ctermbg=234 cterm=NONE
  hi TabLineSel ctermfg=108 ctermbg=235 cterm=NONE
end

highlight Search2 ctermbg=blue ctermfg=black
highlight Search3 ctermbg=red ctermfg=black

" Plugin configs

if has('nvim')
  let g:ranger_map_keys = 0
  "let g:ranger_replace_netrw = 1
endif

let g:markdown_fenced_languages = ['html', 'dot', 'bash=sh', 'sh', 'yml=yaml', 'yaml', 'ruby', 'json', 'groovy', 'css']

let g:elm_setup_keybindings = 0

let g:ansible_options = {'ignore_blank_lines': 0, 'documentation_mapping': 'K'}

" glue between asyncrun and errormarker
let g:asyncrun_auto = "make"

let g:colorizer_nomap = 1
let g:colorizer_startup = 0

let g:ragtag_global_maps = 1

let g:UltiSnipsExpandTrigger="<c-i>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir=$HOME.'/.vim/UltiSnips'

"set wildmenu
set wildmode=list:longest
set wildignore+=*.jpg,*.bmp,*.gif
set wildignore+=coverage
set wildignore+=*~

" Use :confirm A to create new files
" bugs, `:confirm A` only seems to work with alternative
" when using test it should exist as a default for alternative
let g:rails_projections = {
      \   "release/*.rb": {
      \     "alternate": [
      \       "release/spec/{}_spec.rb"
      \     ]
      \   },
      \   "release/spec/*_spec.rb": {
      \     "alternate": [
      \       "release/{}.rb"
      \     ]
      \   },
      \
      \   "app/assets/javascripts/admin/backbone/*.js.coffee": {
      \     "alternate": [
      \       "spec/javascripts/{}_spec.js.coffee"
      \     ]
      \   },
      \   "spec/javascripts/*_spec.js.coffee": {
      \     "alternate": [
      \       "app/assets/javascripts/admin/backbone/{}.js.coffee"
      \     ]
      \   }
      \ }

let g:racer_cmd="racer"

if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif 

" pomodoros / glue for Vomodoro to bin/p
let g:Pomo_ArchiveFilePath = "~/code/sparkleshare/pomodoros_archive.wofl"
let g:Pomo_MinWindowHeight = 10

let g:reek_always_show = 0
let g:reek_line_limit = 1000
let g:reek_on_loading = 0

" open-browser.vim
"let g:netrw_nogx = 0 " disable netrw's gx mapping.
"nmap gx <Plug>(openbrowser-smart-search)
"vmap gx <Plug>(openbrowser-smart-search)

" jasmine
" set errorformat+=%E\ %#Stack:,%C\ %#\ at\ %[%^(]%#\ (%f:%l:%c),%C\ %#%[%^:]%#:\ %m
" let &l:efm = &efm . ',%-G%.%#'

" Abbreviations
iab AC ### Acceptance Criteria
iab <expr> dts strftime("%Y-%m-%d")
iab <expr> dta strftime("%Y-%m-%d %H:%M")
iab <expr> dtz strftime("%Y-%m-%dT%H:%M:%S%z")
" NOTE: this is hardcoded to convert from CET/UTC+1 to UTC, requires manual update
iab <expr> dti strftime("%Y%m%d %H%M", localtime()-3600*1)
iab <expr> paircred fzf#complete({
      \ 'source': 'cd ~/code/promote && git log --pretty="%an <%ae>%n%cn <%ce>" HEAD~300..HEAD \| sort \| uniq -c',
      \ 'reducer': function('PrefixPairCredit'),
      \ 'options': '--multi',
      \ 'prefix': '' })

function! GivePairingCredit()
  " Trigger abbreviation on next line without character insertion
  " This trigger is used to avoid the inserted space
  execute "normal! opaircred"
endfunction

function! PrefixPairCredit(lines)
  " removes count prefix
  return join(map(a:lines, '"Co-authored-by: " . substitute(v:val, "^\\s\\+\\d\\+\\s\\+", "", "")'), "\n")
endfunction

" Mappings

let mapleader = ","
let maplocalleader = "-"

" Create undo-point before delete-to-beginning in insert mode
" This makes it possible to undo back to the exact point before pressing CTRL-U
" In bash you can revert CTRL-U with CTRL-Y
inoremap <C-U> <C-G>u<C-U>

" General
nnoremap <leader>q :quit<CR>
nnoremap <leader>te :UltiSnipsEdit<CR>
nnoremap <leader>td :tabedit ~/code/dotfiles/
nnoremap <leader>tr :source $MYVIMRC<CR>
nnoremap <leader>ti :set ft=html<CR>:%!tidy -iq -xml<CR>

cmap w!! w !sudo tee % >/dev/null
nnoremap <C-s> :w<cr>

map Q qq
nnoremap <space> /
" v<space> (in visual mode, C-U (delete-to-beginning) removes visual range characters
xnoremap <silent> <space> :<C-U>nohlsearch<C-R>=has('diff')?'<bar>diffupdate':''<cr><cr>
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
nnoremap <leader>gs :G<CR>
nnoremap <leader>gc :G commit -v<CR>
nnoremap <leader>gC :G commit -v --amend<CR>
nnoremap <leader>gd :Gvdiffsplit<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gb :G blame<CR>
nnoremap <leader>do :diffoff!<CR>:only<CR>
nnoremap <leader>gp :G push -u<CR>
nnoremap <leader>gP :G push --force-with-lease<CR>
" diff file under cursor
nnoremap <leader>gf :vert :Gdiffsplit <cfile><CR>

" Jobs
nnoremap ! :AsyncRun<space>
nnoremap <silent> <leader>§ :copen<CR>
" same as above but shift, key left of 1
nnoremap <silent> <leader>~ :vert :copen 50<CR>
if has('nvim')
  nnoremap <leader>i :<C-U>Ranger<CR>
  nnoremap <leader>I :<C-U>RangerWorkingDirectory<CR>
else
  nnoremap <leader>i :<C-U>RangerChooser -<CR>
  nnoremap <leader>I :<C-U>RangerChooser .<CR>
endif
nnoremap <leader>o :PomodoroToDoToday<CR>
nnoremap <leader>l :call system("surf_go " . g:url)
"nnoremap <leader>l :w\|call system("export surfwid=" . g:browser_id . " && surf_go " . g:url)
"nnoremap <leader>l :w\|:call system("xdotool windowactivate " . g:browser_id . " key 'ctrl+r'")
nnoremap <leader>l :silent wa\|:exec "AsyncRun sleep 2; send_key_to 'ctrl+r' ".g:browser_id<CR>
"nnoremap <leader>l :silent wa\|:exec "AsyncRun send_key_to 'Return' ".g:browser_id<CR>
nnoremap <leader>p :silent !xdg-open <C-R>=escape("<C-R><C-F>", "#?&;\|%")<CR><CR>
vnoremap <leader>p :w !curl -F 'f:1=<-' ix.io<CR>
nnoremap <silent> <leader>K :silent wa<bar>:K rs <c-r>%<cr><cr>
nnoremap <silent> <leader>L :AsyncRun tmux send-keys -t~ -l "<C-R>=escape(getline("."), "$")<C-V><C-M>"<cr>
nnoremap <silent> <leader>KR :silent wa<bar>:K rspec <c-r>%<cr><cr>
if !exists("g:async_command")
  let g:async_command = 'tmux send-keys -t~ C-p C-m'
endif
nnoremap <silent> <leader>KM :silent wa<bar>:K tmux send-keys -t~ C-p C-m<cr><cr>
nnoremap <silent> <leader>k :silent wa<bar>:KK<cr>
"nnoremap <silent> <leader>k :silent w<bar>:call system("tmux send-keys -t~ C-p C-m")<cr>
"nnoremap <leader>k :silent w\|:exec "AsyncRun sleep 1; send_key_to 'ctrl+r' ".g:browser_id<CR>

" Finders and all other ,, commands
nnoremap <leader><space> :Files<cr>
" include symlinks (when dir is specified)
" added in vim/bundle/fzf.vim/autoload/fzf/vim.vim
nnoremap <leader>,s :Files .<cr>
" siblings
nnoremap <leader>,d :Files %:p:h<cr>
nnoremap <leader>,t :Tags<cr>

nnoremap <leader>,m :Marks<cr>
nnoremap <leader>,w :Windows<cr>
nnoremap <leader>,h :History<cr>
nnoremap <leader>,i :call system("tmux split-window \"tig ".expand("%")."\"")
nnoremap <leader>,o :call system("tmux split-window \"tig\"")
nnoremap <leader>,n :Snippets<cr>
nnoremap <leader>,c :Commits<cr>
nnoremap <leader>,b :BCommits<cr>
nnoremap <leader>,v :Maps<cr>
nnoremap <leader>,e :Helptags<cr>
nnoremap <leader>,r :.,/END CERTIFICATE/w !sed "s/^ *//g;s/'//" \| openssl x509 -text -noout -dates<cr>
xnoremap <leader>,r :w !i=`cat`; echo "-----BEGIN CERTIFICATE-----\n$i\n-----END CERTIFICATE-----\n" \| openssl x509 -text -noout<cr>
nnoremap <leader>,f :.,/END CERTIFICATE/w !sed "s/^ *//g;s/'//" \| openssl x509 -noout -fingerprint -sha1 -inform pem<cr>
xnoremap <leader>,f :w !i=`cat`; echo "-----BEGIN CERTIFICATE-----\n$i\n-----END CERTIFICATE-----\n" \| openssl x509 -noout -fingerprint -sha1 -inform pem<cr>

nnoremap <leader>j :GitFilesModified<cr>
nnoremap <leader>J :GitFilesModifiedBranch<cr>

nnoremap <leader>f§ :lopen<CR>
nnoremap <leader>fc :call setloclist(0, [])<CR>:lclose<CR>
nnoremap <leader>ff :LAck! <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>fF :LAck! <c-r>=expand("<CWORD>")<CR><CR>
nnoremap <leader>fa :LAck "" <left><left>
nnoremap <leader>ft :tabnew<CR>:LAck "" <left><left>
" find pending items with dates
nnoremap <leader>fd :vimgrep /\v^\s*\*[^\d]*\d{4}-\d{2}-\d{2}/ %<CR>

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
nnoremap <silent> <C-j> :call LocationOrWindowMove("j")<CR>
nnoremap <silent> <C-k> :call LocationOrWindowMove("k")<CR>
nnoremap <silent> <C-l> <C-w>l

function! LocationOrWindowMove(a)
  if 0 == getloclist(0, {'size': 1})['size']
    exec "normal \<C-w>" . a:a
  else
    if a:a == "j"
      :lnext
    elseif a:a == "k"
      :lprevious
    end
  end
endfunction

nnoremap ö :
nnoremap Ö :
nnoremap ä ]`
nnoremap Ä [`
nnoremap <C-p> :cprevious<CR>zv
nnoremap <C-n> :cnext<CR>zv
nnoremap å `

" Parenthesis/bracket expanding
vnoremap §r <esc>`>a)<esc>`<i(<esc>
vnoremap §f <esc>`>a]<esc>`<i[<esc>
vnoremap §v <esc>`>a}<esc>`<i{<esc>
vnoremap §q <esc>`>a'<esc>`<i'<esc>
vnoremap §w <esc>`>a"<esc>`<i"<esc>
vnoremap §x <esc>`>a><esc>`<i<<esc>

" TODO: figure out how to not escape, or to capture into repeatable action
" Map auto complete of (, ", ', [
inoremap §r ()<esc>i
inoremap §f []<esc>i
inoremap §v {}<esc>i
inoremap §3 #{}<esc>i
inoremap §e (<esc>o)<esc>O
inoremap §d [<esc>o]<esc>O
inoremap §c {<esc>o}<esc>O
inoremap §q ''<esc>i
inoremap §w ""<esc>i
inoremap §x <><esc>i

" useful after using above maps
inoremap <C-l> <Right>
cnoremap <C-l> <Right>

" ctrl+altgr+g
cno  <C-\>eDeleteTillSlash()<cr>

command! -nargs=1 -complete=customlist,CompleteKCommand K call RunCommand('<args>')
command! -nargs=0 KK call ReRunCommand()
function! RunCommand(command)
  let g:async_command = a:command
  call ReRunCommand()
endfunction

function! ReRunCommand()
  if g:async_command =~ '^:'
    exec g:async_command
  else
    exec 'AsyncRun ' . g:async_command
  end
endfunction

function! CompleteKCommand(ArgLead, CmdLine, CursorPos)
  return [
        \"rs .",
        \"tmux send-keys -t~ C-p C-m",
        \"tmux send-keys -t~ C-c C-p C-m",
        \]
endfunction

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
    "cclose
  end
endfunction

function! SelectBrowser()
  let g:browser_id = systemlist("xdotool selectwindow 2> /dev/null")[0]
endfunction

function! SetupWoflToPomodoroBuffer()
  nnoremap <buffer> <silent> <CR> :call CopyToBelowFromWorkflowish()<cr>
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

function! RangeSelect(path)
  if a:path == "-"
    if getreg("%") == ""
      let path = "."
    else
      let path = "--selectfile " . shellescape(expand("%:p"))
    end
  else
    let path = shellescape(a:path)
  end
  let temp = tempname()
  exec 'silent !ranger --choosefiles=' . shellescape(temp) . ' ' . path
  if !filereadable(temp)
    return []
  else
    return readfile(temp)
  end
endfunction

function! RangeChooser(path)
  let names = RangeSelect(a:path)
  if !empty(names)
    exec 'edit ' . fnameescape(names[0])
    for name in names
      exec '$argadd ' . fnameescape(name)
    endfor
  end
  redraw!
endfunction
command! -bar -nargs=? -complete=file RangerChooser call RangeChooser(<f-args>)

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

if filereadable($HOME.'/.local_db.vim')
  source $HOME/.local_db.vim
endif
