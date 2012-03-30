""
"" Thanks:
""   Gary Bernhardt  <destroyallsoftware.com>
""   Drew Neil  <vimcasts.org>
""   Tim Pope  <tbaggery.com>
""   Janus  <github.com/carlhuda/janus>
"   "
set enc=UTF-8
set encoding=utf-8
set fileencodings=utf-8,euc-kr
let hangeul_enabled = 1
set fencs=utf-8,euc-kr,cp949,cp932,euc-jp,shift-jis,big5,latin1,ucs-2l
set nocompatible
"pathogen
runtime! autoload/pathogen.vim
if exists('g:loaded_pathogen')
  call pathogen#runtime_append_all_bundles()
  call pathogen#helptags()
  call pathogen#infect()
endif

filetype plugin indent on

"navigating tabs
:nmap <C-n> :tabnew<CR>
:imap <C-n> <Esc>:tabnew<CR>
map th :tabfirst<CR>
map tl :tablast<CR>
map tj :tabprevious<CR>
map tk :tabnext<CR>
map tt :tabedit<Space>
map tm :tabm<Space>
map tn :tabnext<Space>
"   CtrlP Plugin
"let g:ctrlp_map = '<c-p>'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

let g:ctrlp_by_filename = 1
let g:ctrlp_open_new_file = 1
let g:ctrlp_open_multi = '1t'
let g:ctrlp_follow_symlinks = 1

let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': ['<c-t>'],
  \ 'AcceptSelection("t")': ['<cr>']
  \ }

"==== using ctags with vim
" http://effectif.com/vim/using-ctags-with-bundler-gems
set tags+=gems.tags

"===== vim-css3-syntax
" ~/.vim/after/syntax/html.vim
"===== vim-css-color
let g:cssColorVimDoNotMessMyUpdatetime = 1

"===== LESS
nnoremap ,m :w <BAR> !lessc % > %:t:r.css<CR><space>

"===== coffeescript things
"standard two-space indentation in CoffeeScript files
au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
" fold by indentation in CoffeeScript files
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable

"With this, folding is disabled by default but can be quickly toggled per-file
"by hitting zi. To enable folding by default, remove nofoldenable:
"au BufNewFile,BufReadPost *.coffee setl foldmethod=indent
hi Normal ctermfg=252 ctermbg=237 term=standout
set t_Co=256
syntax enable
if has('gui_running')
  set background=light
else
  set background=dark
endif
"colorscheme solarized
let g:solarized_termcolors=256
"color molokai
"color zenburn
color vibrantink
set nonumber
"set number
set ruler       " show the cursor position all the time
set cursorline
set showcmd     " display incomplete commands
set shell=bash  " avoids munging PATH under zsh

"ack conf depend on OS
if has("unix")
  let s:uname = system("uname")
  let g:ackprg="ack-grep -H --nocolor --nogroup --column"
  if s:uname == "Darwin\n"
    let g:ackprg="ack -H --nocolor --nogroup --column"
  endif
endif

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

"" Whitespace
"set nowrap                        " don't wrap lines
set wrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode
" List chars
set listchars=""                  " Reset the listchars
set listchars=tab:\ \             " a tab should display as "  ", trailing whitespace as "."
"set listchars+=trail:.            " show trailing spaces as dots
set listchars+=extends:>          " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the first column when wrap is
                                  " off and the line continues beyond the left of the screen
"" Searching
set hlsearch                      " highlight matches
set incsearch                     " incremental searching
set ignorecase                    " searches are case insensitive...
set smartcase                     " ... unless they contain at least one capital letter

function s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=80
endfunction

if has("autocmd")
  " In Makefiles, use real tabs, not tabs expanded to spaces
  au FileType make set noexpandtab

  " Make sure all markdown files have the correct filetype set and setup wrapping
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown | call s:setupWrapping()

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json set ft=javascript

  " make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
  au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif

" provide some context when editing
set scrolloff=3

" don't use Ex mode, use Q for formatting
map Q gq

" clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>

let mapleader=","

"map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
"map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
"map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
"map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
"map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
"map <leader>gf :CommandTFlush<cr>\|:CommandT features<cr>
"map <leader>gg :topleft 100 :split Gemfile<cr>
"map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>
"map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>

" ignore Rubinius, Sass cache files
set wildignore+=tmp/**,*.rbc,.rbx,*.scssc,*.sassc

nnoremap <leader><leader> <c-^>

" find merge conflict markers
nmap <silent> <leader>cf <ESC>/\v^[<=>]{7}( .*\|$)<CR>

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" disable cursor keys in normal mode
map <Left>  :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up>    :echo "no!"<cr>
map <Down>  :echo "no!"<cr>

set backupdir=~/.vim/_backup    " where to put backup files.
set directory=~/.vim/_temp      " where to put swap files.

if has("statusline") && !&cp
  set laststatus=2  " always show the status bar

  " Start the status line
  set statusline=%f\ %m\ %r

  " Add fugitive
  set statusline+=%{fugitive#statusline()}

  " Finish the statusline
  set statusline+=Line:%l/%L[%p%%]
  set statusline+=Col:%v
  set statusline+=Buf:#%n
  set statusline+=[%b][0x%B]
endif
