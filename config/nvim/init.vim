set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set guifont=Ubuntu\ Mono:h32
" neovide config
let g:neovide_cursor_animation_length = 0
let g:neovide_cursor_trail_length = 0
