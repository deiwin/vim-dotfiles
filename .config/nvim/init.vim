"*****************************************************************************
"" NeoBundle core
"*****************************************************************************

if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=~/.config/nvim/bundle/neobundle.vim/
endif

let neobundle_readme=expand('~/.config/nvim/bundle/neobundle.vim/README.md')

if !filereadable(neobundle_readme)
  echo "Installing NeoBundle..."
  echo ""
  silent !mkdir -p ~/.config/nvim/bundle
  silent !git clone https://github.com/Shougo/neobundle.vim ~/.config/nvim/bundle/neobundle.vim/
  let g:not_finsh_neobundle = "yes"
endif

" Required:
call neobundle#begin(expand('~/.config/nvim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

"*****************************************************************************
"" NeoBundle install packages
"*****************************************************************************
NeoBundle 'justinmk/vim-dirvish'
" For useful file/dir commands
NeoBundle 'tpope/vim-eunuch'

NeoBundle 'tpope/vim-commentary'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'sheerun/vim-polyglot'
NeoBundle 'vim-scripts/CSApprox'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'bronson/vim-trailing-whitespace'
NeoBundle 'vim-scripts/vis'

"" Vim-Session
NeoBundle 'xolox/vim-misc'
NeoBundle 'xolox/vim-session'

"" Color
NeoBundle 'chriskempson/base16-vim'
" Enable ansi escape seq colors
NeoBundle 'vim-scripts/AnsiEsc.vim'

"" Custom bundles
NeoBundle 'ludovicchabant/vim-gutentags'
NeoBundle 'pearofducks/ansible-vim'
NeoBundle 'Shougo/deoplete.nvim'
let s:hooks = neobundle#get_hooks("deoplete.nvim")
function! s:hooks.on_source(bundle)
    let g:deoplete#enable_at_startup = 1
endfunction
NeoBundle 'junegunn/limelight.vim'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-surround'
NeoBundle 'wellle/targets.vim'
NeoBundle 'tmux-plugins/vim-tmux-focus-events'
NeoBundle 'tmux-plugins/vim-tmux'
NeoBundle 'karlbright/qfdo.vim'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'janko-m/vim-test'
NeoBundle 'benmills/vimux'
NeoBundle 'michaeljsmith/vim-indent-object'
NeoBundle 'superbrothers/vim-vimperator'
NeoBundle 'haya14busa/incsearch.vim'

NeoBundle 'chaoren/vim-wordmotion'

NeoBundle 'benekastah/neomake'
NeoBundle 'benjie/neomake-local-eslint.vim'

NeoBundle 'LucHermitte/lh-vim-lib'
NeoBundle 'LucHermitte/local_vimrc'

"" Go Lang Bundle
NeoBundle "fatih/vim-go"


"" Javascript Bundle
NeoBundle 'kchmck/vim-coffee-script', {
    \ 'autoload' : {
       \ 'filename_patterns' : [ "\.coffee$", "\.cjsx$" ]
    \ }
  \ }
NeoBundle 'ternjs/tern_for_vim', { 'build': 'npm install' }


"" Ruby Bundle
NeoBundle "vim-ruby/vim-ruby"

"" HTML Bundle
NeoBundle 'vim-scripts/HTML-AutoCloseTag'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'tpope/vim-haml'

"" Haskell Bundle
NeoBundle 'Shougo/vimproc.vim', {
      \   'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'linux' : 'make',
      \     'unix' : 'gmake',
      \   }
      \ }
NeoBundle 'eagletmt/ghcmod-vim'
NeoBundle 'dag/vim2hs'
NeoBundle 'vmchale/dhall-vim'
NeoBundle 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
"" TODO Also check out https://github.com/haskell/haskell-ide-engine#using-hie-with-vim-or-neovim

"" Scheme and other Lisp-y things
NeoBundle 'guns/vim-sexp'
NeoBundle 'tpope/vim-sexp-mappings-for-regular-people'
NeoBundle 'kien/rainbow_parentheses.vim'
NeoBundle 'jpalardy/vim-slime'

"" Clojure
NeoBundle 'guns/vim-clojure-static'
NeoBundle 'guns/vim-clojure-highlight'
NeoBundle 'tpope/vim-fireplace'
NeoBundle 'tpope/vim-classpath'

"" Prose editing
NeoBundle 'godlygeek/tabular'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'reedes/vim-pencil'
NeoBundle 'reedes/vim-wordy'

"" Elixir
NeoBundle 'elixir-editors/vim-elixir'
NeoBundle 'slashmili/alchemist.vim'
NeoBundle 'mhinz/vim-mix-format'

"" Java
NeoBundle 'artur-shaik/vim-javacomplete2'

"" Swift & iOS
NeoBundle 'keith/swift.vim'
NeoBundle 'landaire/deoplete-swift'

"" Include user's extra bundle
if filereadable(expand("~/.config/nvim/local.bundles"))
  source ~/.config/nvim/local.bundles
endif

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

" Set up binding for dirvish
function! OpenDirvish()
  if bufname('%') == ''
    :Dirvish
  else
    :Dirvish %
  endif
endfunction
map <silent> - :call OpenDirvish()<CR>

" Set up bindings for sub-word motions
let g:wordmotion_prefix = ','

let g:neomake_javascript_enabled_makers = ['eslint']
" Configure neomake to run on every save
augroup neomake-autosave
  autocmd!
  au BufWritePost * Neomake
augroup END

"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

"" Fix backspace indent
set backspace=indent,eol,start

"" Map leader to space
let mapleader="\<space>"

"" Enable hidden buffers
set hidden

"" Searching
set ignorecase
set smartcase

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" :h g:incsearch#auto_nohlsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

"" Encoding
set bomb
set binary

"" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=2
set shiftwidth=2
set expandtab


"" Directories for swp files
set nobackup
set noswapfile

set fileformats=unix,dos,mac
set showcmd
set shell=/bin/sh

" session management
let g:session_directory = "~/.config/nvim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

"*****************************************************************************
"" Visual Settings
"*****************************************************************************
syntax on
set ruler
set number

let no_buffers_menu=1
set termguicolors
if !exists('g:not_finsh_neobundle')
  " set background=light
  " colorscheme base16-paraiso
  set background=dark
  colorscheme base16-3024
endif

set mousemodel=popup
" Disable mouse selection entering the Visual mode
"set mouse-=a
" But I need mouse=a for scolling to work in tmux
set mouse=a
set t_Co=256
set nocursorline
set guioptions=egmrti
set gfn=Monospace\ 10

if has("gui_running")
  if has("gui_mac") || has("gui_macvim")
    set guifont=Menlo:h12
    set transparency=7
  endif
else
  let g:CSApprox_loaded = 1

  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color
  else
    if $TERM == 'xterm'
      set term=xterm-256color
    endif
  endif
endif

if &term =~ '256color'
  set t_ut=
endif

"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

"" Status bar
set laststatus=2

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

if exists("*gutentags#statusline")
  set statusline+=%{gutentags#statusline()}
endif

" vim-airline
let g:airline_theme = 'base16_3024'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

if !exists('g:airline_powerline_fonts')
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'
else
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''

  " powerline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
endif
"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync fromstart
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

"" js/coffee/html
augroup vimrc-js
  autocmd!
  autocmd FileType coffee setlocal tabstop=4 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType javascript setlocal tabstop=4 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType javascript.jsx setlocal tabstop=4 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType html setlocal tabstop=4 softtabstop=2 shiftwidth=2 expandtab
augroup END

"" Haskell
" Add Stack binaries to path to use e.g. intero
function! AddStackPath()
  let stack_path = system("stack path --bin-path")
  if v:shell_error
    return 0
  endif
  let $PATH = stack_path
endfunction

augroup vimrc-haskell
  autocmd!
  autocmd FileType haskell setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
  autocmd FileType haskell call AddStackPath()
  autocmd FileType haskell setlocal formatprg=brittany
augroup END

"*****************************************************************************
"" Mappings
"*****************************************************************************
"" Split
noremap <Leader>o :<C-u>split<CR>
noremap <Leader>i :<C-u>vsplit<CR>
noremap <Leader>O :<C-u>botright split<CR>
noremap <Leader>I :<C-u>botright vsplit<CR>

"make splits open below and to the right
set splitbelow
set splitright

"" Git
noremap <Leader>ga :Gwrite<CR>
" Make the default commit binding be verbose
noremap <Leader>gc :Gcommit -v<CR>
noremap <Leader>gsh :Gpush<CR>
noremap <Leader>gll :Gpull<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>
" Remap hunk staging etc to not clash with split navigation's <leader>h
"GitGutterStageHunk
nmap <leader>cs <Plug>(GitGutterStageHunk)
nmap <leader>cp <Plug>(GitGutterPreviewHunk)
nmap <leader>cr <Plug>(GitGutterRevertHunk)
nmap <leader>cu <Plug>(GitGutterUndoHunk)

" session management
nnoremap <leader>so :OpenSession
nnoremap <leader>ss :SaveSession
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sc :CloseSession<CR>

"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

"" ctrlp.vim
set wildmode=list:longest,list:full
let g:ctrlp_use_caching = 0
cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
noremap <leader>b :CtrlPBuffer<CR>
noremap <leader>t :CtrlPTag<CR>
let g:ctrlp_map = '<leader>e'
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_root_markers = ['start', 'package.json', 'mix.lock', 'Gemfile.lock']

if executable('ag')
  " Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast, respects .gitignore
  " and .agignore. Ignores hidden files by default.
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_user_command_async = 1
else
  "ctrl+p ignore files in .gitignore
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
endif

nnoremap <C-f> :LAck!<SPACE>
nnoremap <leader>f :LAck! <C-R><C-W>
" yank the current visual selection and insert it as the search term
vnoremap <leader>f y:<C-u>LAck! "<C-r>0"<space>

let g:ackprg = 'ag --vimgrep --smart-case'
let g:ack_lhandler="lopen"
let g:ackhighlight=1
let g:miniBufExplSplitBelow=0
" End Ag

"" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

noremap YY "+y<CR>
noremap XX "+x<CR>

if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

"" Buffer nav
noremap <leader>p :bp<CR>
noremap <leader>n :bn<CR>
"" Close buffer
" Open a previously edited buffer and then close the buffer we just moved away
" from. This avoids closing the split due to closing the buffer.
noremap <leader>q :b#\|bd #<CR>
"" Closing bufs that aren't open in any window or tabs
" from http://stackoverflow.com/a/7321131/1456578
function! DeleteInactiveBufs()
  "From tabpagebuflist() help, get a list of all buffers in all tabs
  let tablist = []
  for i in range(tabpagenr('$'))
    call extend(tablist, tabpagebuflist(i + 1))
  endfor

  "Below originally inspired by Hara Krishna Dara and Keith Roberts
  "http://tech.groups.yahoo.com/group/vim/message/56425
  let nWipeouts = 0
  for i in range(1, bufnr('$'))
    if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
      "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
      silent exec 'bwipeout' i
      let nWipeouts = nWipeouts + 1
    endif
  endfor
  echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
noremap <leader>Q :call DeleteInactiveBufs()<CR>

"" Split nav
" a fix for <C-h> in iterm
if has('nvim')
  nmap <BS> <C-w>h
endif
noremap <leader>h  <C-w>h
noremap <leader>j  <C-w>j
noremap <leader>k  <C-w>k
noremap <leader>l  <C-w>l
noremap <leader>wr <C-w>r
"nnoremap <C-S-h> :wincmd H<cr>
"nnoremap <C-S-k> :wincmd K<cr>
"nnoremap <C-S-l> :wincmd L<cr>
"nnoremap <C-S-j> :wincmd J<cr>

"" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr> :syntax sync fromstart<cr>

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Open current line on GitHub
noremap ,o :!echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>

"" Custom configs

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:gutentags_ctags_executable = 'ctags-ignore'
let g:gutentags_project_root = ['package.json', 'Brocfile.js', 'Capfile', 'Rakefile', 'bower.json', '.ruby-version', 'Gemfile', 'stack.yaml']
let g:gutentags_project_info = []
call add(g:gutentags_project_info, {'type': 'ruby', 'file': 'Gemfile'})
call add(g:gutentags_project_info, {'type': 'javascript', 'file': 'package.json'})
call add(g:gutentags_project_info, {'type': 'haskell', 'file': 'stack.yaml'})
" Use -R because es-ctags doesn't support --options used by Gutentags to
" specify the recursiveness
let g:gutentags_ctags_executable_javascript = 'es-ctags -R'
let g:gutentags_ctags_executable_haskell = 'haskell-ctags'

augroup vimrc-go
  autocmd!
  " Fix vim-go leaving scratch buffers open
  au CompleteDone * pclose
  "" vim-go bindings
  au FileType go nmap <Leader>gd <Plug>(go-doc)
  au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
  au FileType go nmap <Leader>gs <Plug>(go-implements)
  au FileType go nmap <Leader>gi <Plug>(go-info)
  au FileType go nmap <Leader>ge <Plug>(go-rename)

  au FileType go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

  au FileType go let g:deoplete#disable_auto_complete = 1
augroup END


let g:javascript_enable_domhtmlcss = 1


let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

augroup vimrc-ruby
  autocmd!
  autocmd BufNewFile,BufRead *.rb,*.rbw,*.gemspec setlocal filetype=ruby
  autocmd FileType ruby setlocal tabstop=4 softtabstop=2 shiftwidth=2 expandtab
augroup END

"" Enable automatic word wrapping
set formatoptions+=t


"" Include user's local vim config
if filereadable(expand("~/.config/nvim/init.local"))
  source ~/.config/nvim/init.local
endif

"" Limelight
nmap <silent> <leader>m :Limelight!!<CR>
vmap <silent> <leader>m :Limelight!!<CR>
" Not currently a feature :/
"let g:limelight_buffer_local = 1

"" Refresh all buffers. Used after git rebasing and such
set autoread
" Mnemonic for git refresh
nmap <leader>gr :checktime<CR>

"" Run tests in a neovim or tmux split
nmap <silent> <leader>r :TestNearest<CR>
nmap <silent> <leader>R :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tg :TestVisit<CR>
if has('nvim')
  function! NeovimSplit(cmd)
    :w
    :split
    :enew
    :call termopen([&sh, &shcf, a:cmd])
    :startinsert
  endfunction

  let g:test#custom_strategies = {'neovim_split': function('NeovimSplit')}
  let g:test#strategy = 'neovim_split'
  " Use <esc> to get to normal mode in the terminal split
  tnoremap <esc> <C-\><C-n>
else
  let g:test#strategy = 'vimux'
endif

augroup vimrc-elixir
  autocmd!
  " This is required within Elixir umbrella projects, but is problematic in
  " e.g. Go.
  au FileType elixir let test#filename_modifier = ":p"
augroup END
let g:neomake_elixir_dialyzer_maker = {
    \ 'exe': 'mix',
    \ 'args': ['dialyzer'],
    \ 'append_file': 0
    \ }
let g:neomake_elixir_enabled_makers = ['mix', 'credo', 'dialyzer']
let g:mix_format_on_save = 1

"" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
vmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Highlight 121st column if text flows over it
highlight ColorColumn ctermbg=red guibg=#ed2939
call matchadd('ColorColumn', '\%121v', 100)

function! Prose()
  call pencil#init()

  setlocal spell
  " Suggest spelling fixes
  nnoremap <localleader>s ea<C-X><C-S>
endfunction
" Allow calling it directly as well
command! -nargs=0 Prose call Prose()

augroup vim-text
  autocmd!
  au FileType markdown,gitcommit,text call Prose()
augroup END
set spelllang=en_us
set spellfile=~/.config/nvim/spell/mydict.utf-8.add

"" Autosave
augroup autosave
  autocmd!
  au FocusLost * silent! wa
augroup END
set autowriteall

"" Scheme and other Lisp-y langs
function! OpenSlimeCMDInSplit(cmd)
  if !exists('g:slime_default_config')
    split
    enew
    call termopen(a:cmd)
    let g:slime_default_config = b:terminal_job_id
    let g:slime_dont_ask_default = 1
    " go to previous split
    execute 'normal!' . "\<c-w>p"
  endif
endfunction
function! OpenSchemeREPLOrReloadCurrentFile()
  call OpenSlimeCMDInSplit(['with-readline', 'racket', '-i'])
  call jobsend(g:slime_default_config, '(load "'.expand('%')."\")\<cr>")
endfunction

augroup vimrc-scheme
  autocmd!
  au FileType scheme RainbowParenthesesActivate
  au FileType scheme RainbowParenthesesLoadRound
  au FileType scheme RainbowParenthesesLoadSquare
  au FileType scheme RainbowParenthesesLoadBraces
  au FileType scheme nmap <leader>z :call OpenSchemeREPLOrReloadCurrentFile()<CR>
augroup END

let g:slime_target = "neovim"
let g:slime_paste_file = tempname()
let g:slime_no_mappings = 1
xmap <leader>x <Plug>SlimeRegionSend
nmap <leader>x <Plug>SlimeParagraphSend
" Remap from default <leader>rwp to avoid having to wait after using <leader>r
nmap <leader>wpr <Plug>RestoreWinPosn

function! OpenClojureREPL()
  call OpenSlimeCMDInSplit(['lein', 'repl'])
endfunction
augroup vimrc-clojure
  autocmd!
  au FileType clojure RainbowParenthesesActivate
  au Syntax clojure RainbowParenthesesLoadRound
  au Syntax clojure RainbowParenthesesLoadSquare
  au Syntax clojure RainbowParenthesesLoadBraces
  au FileType clojure nmap <leader>z :call OpenClojureREPL()<CR>
augroup END

let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_frontmatter = 1

augroup vimrc-java
  autocmd!
  au FileType java setlocal omnifunc=javacomplete#Complete
augroup END
