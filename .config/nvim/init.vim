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

  " Run shell script if exist on custom select language

  silent !\curl -sSL https://raw.githubusercontent.com/avelino/vim-bootstrap/master/vim_template/langs/go/go.sh | bash -s stable

  silent !\curl -sSL https://raw.githubusercontent.com/avelino/vim-bootstrap/master/vim_template/langs/javascript/javascript.sh | bash -s stable

  silent !\curl -sSL https://raw.githubusercontent.com/avelino/vim-bootstrap/master/vim_template/langs/ruby/ruby.sh | bash -s stable

  silent !\curl -sSL https://raw.githubusercontent.com/avelino/vim-bootstrap/master/vim_template/langs/html/html.sh | bash -s stable

endif

" Required:
call neobundle#begin(expand('~/.config/nvim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

"*****************************************************************************
"" NeoBundle install packages
"*****************************************************************************
" wait until this gets fixed: https://github.com/tpope/vim-vinegar/issues/13
" meanwhile use filebeagle instead
"NeoBundle 'tpope/vim-vinegar'
" To avoid filebeagle mapping <leader>f, suppress keymaps and then remap rest
NeoBundle 'jeetsukumaran/vim-filebeagle'
let g:filebeagle_suppress_keymaps = 1
map <silent> - <Plug>FileBeagleOpenCurrentBufferDir

NeoBundle 'tpope/vim-commentary'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'bling/vim-airline'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'sheerun/vim-polyglot'
NeoBundle 'vim-scripts/grep.vim'
NeoBundle 'rking/ag.vim'
NeoBundle 'vim-scripts/CSApprox'
NeoBundle 'bronson/vim-trailing-whitespace'
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
if v:version > 702
	NeoBundle 'Shougo/vimshell.vim'
endif

"" Vim-Session
NeoBundle 'xolox/vim-misc'
NeoBundle 'xolox/vim-session'

"" Snippets
NeoBundle 'SirVer/ultisnips'
NeoBundle 'honza/vim-snippets'

"" Color
NeoBundle 'chriskempson/base16-vim'
" Enable ansi escape seq colors
NeoBundle 'vim-scripts/AnsiEsc.vim'

"" Vim-Bootstrap Updater
NeoBundle 'sherzberg/vim-bootstrap-updater'

let g:vim_bootstrap_langs = "javascript,ruby,html,go"
let g:vim_bootstrap_editor = "nvim"				" nvim or vim

"" Custom bundles
NeoBundle 'ludovicchabant/vim-gutentags'
NeoBundle 'chase/vim-ansible-yaml'
NeoBundle 'Valloric/YouCompleteMe', {
     \ 'build'      : {
        \ 'mac'     : './install.sh --clang-completer --system-libclang --omnisharp-completer',
        \ 'unix'    : './install.sh --clang-completer --system-libclang --omnisharp-completer',
        \ 'windows' : './install.sh --clang-completer --system-libclang --omnisharp-completer',
        \ 'cygwin'  : './install.sh --clang-completer --system-libclang --omnisharp-completer'
        \ }
     \ }
let g:neobundle#install_process_timeout = 1500
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

"" CamelCaseMotion requires bindings to be declared before it is required
map ,w <Plug>CamelCaseMotion_w
map ,b <Plug>CamelCaseMotion_b
map ,e <Plug>CamelCaseMotion_e
omap i,w <Plug>CamelCaseMotion_iw
xmap i,w <Plug>CamelCaseMotion_iw
omap i,b <Plug>CamelCaseMotion_ib
xmap i,b <Plug>CamelCaseMotion_ib
omap i,e <Plug>CamelCaseMotion_ie
xmap i,e <Plug>CamelCaseMotion_ie
NeoBundle 'bkad/CamelCaseMotion'

"" Go Lang Bundle
NeoBundle "majutsushi/tagbar"
NeoBundle "fatih/vim-go"
" Fix vim-go leaving scratch buffers open
autocmd CompleteDone * pclose


"" Javascript Bundle
NeoBundle "scrooloose/syntastic"
NeoBundle 'kchmck/vim-coffee-script', {
    \ 'autoload' : {
       \ 'filename_patterns' : [ "\.coffee$", "\.cjsx$" ]
    \ }
  \ }


"" Ruby Bundle
NeoBundle "tpope/vim-rails"
NeoBundle "tpope/vim-rake"
NeoBundle "tpope/vim-projectionist"
NeoBundle "thoughtbot/vim-rspec"
NeoBundle "majutsushi/tagbar"


"" HTML Bundle
NeoBundle 'amirh/HTML-AutoCloseTag'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'tpope/vim-haml'
NeoBundle 'mattn/emmet-vim'



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

"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=2
set shiftwidth=2
set expandtab

"" Map leader to space
let mapleader="\<space>"

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Encoding
set bomb
set binary


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
if !exists('g:not_finsh_neobundle')
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
let g:airline_theme = 'powerlineish'
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1

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

"" Ag
nnoremap <leader>f :Ag! <C-R><C-W>
" yank the current visual selection and insert it as the search term
vnoremap <leader>f y:<C-u>Ag! "<C-r>0"<space>

" vimshell.vim
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_prompt =  '$ '

" terminal emulation
if g:vim_bootstrap_editor == 'nvim'
  nnoremap <silent> <leader>sh :terminal<CR>
else
  nnoremap <silent> <leader>sh :VimShellCreate<CR>
endif

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
  autocmd FileType html setlocal tabstop=4 softtabstop=2 shiftwidth=2 expandtab
augroup END

augroup git-commit
  autocmd!
  au FileType gitcommit setlocal spell spelllang=en_us
augroup END

set autoread

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
nmap <leader>cs <Plug>GitGutterStageHunk
nmap <leader>cp <Plug>GitGutterPreviewHunk
nmap <leader>cr <Plug>GitGutterRevertHunk

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
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|tox)$'
let g:ctrlp_user_command = "find %s -type f | grep -Ev '"+ g:ctrlp_custom_ignore +"'"
let g:ctrlp_use_caching = 0
cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
noremap <leader>b :CtrlPBuffer<CR>
noremap <leader>t :CtrlPTag<CR>
let g:ctrlp_map = '<leader>e'
let g:ctrlp_open_new_file = 'r'

" Ag
if executable('ag')
  " Use ag over grep
	set grepprg=ag\ --nogroup\ --nocolor

	" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
	let g:ctrlp_root_markers = ['start', 'package.json']

	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0
endif

let g:ag_highlight=1
nnoremap <C-f> :Ag!<SPACE>
let g:miniBufExplSplitBelow=0
" End Ag

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<C-e>"
let g:UltiSnipsJumpForwardTrigger = "<C-n>"
let g:UltiSnipsJumpBackwardTrigger = "<C-p>"
let g:UltiSnipsEditSplit="vertical"

" syntastic
let g:syntastic_always_populate_loc_list=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_error_symbol='✗'
let g:syntastic_style_warning_symbol='⚠'
let g:syntastic_auto_loc_list=1
let g:syntastic_aggregate_errors=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute " ,"trimming empty <", "unescaped &" , "lacks \"action", "is not recognized!", "discarding unexpected"]


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
nnoremap <silent> <leader><space> :noh<cr>

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Open current line on GitHub
noremap ,o :!echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>

"" Custom configs

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Tagbar
nmap <silent> <C-t> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

let g:gutentags_project_root = ['package.json', 'Brocfile.js', 'Capfile', 'Rakefile', 'bower.json', '.ruby-version', 'Gemfile']

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [  'p:package', 'i:imports:1', 'c:constants', 'v:variables',
        \ 't:types',  'n:interfaces', 'w:fields', 'e:embedded', 'm:methods',
        \ 'r:constructor', 'f:functions' ],
    \ 'sro' : '.',
    \ 'kind2scope' : { 't' : 'ctype', 'n' : 'ntype' },
    \ 'scope2kind' : { 'ctype' : 't', 'ntype' : 'n' },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }

let g:tagbar_type_ruby = {
    \ 'kinds' : [
        \ 'm:modules',
        \ 'c:classes',
        \ 'd:describes',
        \ 'C:contexts',
        \ 'f:methods',
        \ 'F:singleton methods'
    \ ]
\ }


augroup vimrc-go
  autocmd!
  "" vim-go bindings
  au FileType go nmap <Leader>gd <Plug>(go-doc)
  au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
  au FileType go nmap <Leader>gs <Plug>(go-implements)
  au FileType go nmap <Leader>gi <Plug>(go-info)
  au FileType go nmap <Leader>ge <Plug>(go-rename)

  au FileType go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
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

"" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
vmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Highlight 121st column if text flows over it
highlight ColorColumn ctermbg=red guibg=#ed2939
call matchadd('ColorColumn', '\%121v', 100)

augroup vim-prose
  autocmd!
  au BufNewFile,BufRead *.md,*.txt,*.prose setlocal filetype=prose
  au FileType prose set textwidth=79
  au FileType prose setlocal formatoptions=aw2tq
  au FileType prose setlocal nonumber
  au FileType prose setlocal spell spelllang=en_us
  " Suggest spelling fixes
  au FileType prose nnoremap \s ea<C-X><C-S>

  " Create left margin and un-higlight it
  au FileType prose setlocal foldcolumn=12
  au FileType prose highlight! link FoldColumn Normal

  " Turn GitGutter to always have the column (to avoid the text jumping back
  " and forth when the column is created/deleted) and change the background of
  " the column to the normal (black background).
  au FileType prose let g:gitgutter_sign_column_always=1
  au FileType prose highlight! link SignColumn Normal
  au FileType prose highlight GitGutterAdd ctermbg=bg guibg=bg
  au FileType prose highlight GitGutterChange ctermbg=bg guibg=bg
  au FileType prose highlight GitGutterDelete ctermbg=bg guibg=bg
  au FileType prose highlight GitGutterChangeDelete ctermbg=bg guibg=bg
augroup END

