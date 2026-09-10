"*****************************************************************************
"" Plugins
"*****************************************************************************

" Managed by vim.pack, built into Nvim. Plugins live under
" stdpath('data')/site/pack/core/opt and each one's revision is recorded in
" ~/.config/nvim/nvim-pack-lock.json.
"
" :lua vim.pack.update()                            update all, review, :w to accept
" :lua vim.pack.update({'name'})                    update one
" :lua vim.pack.update(nil, {target = 'lockfile'})  go back to the recorded revisions
" :lua vim.pack.update(nil, {offline = true})       list what is installed

lua << EOF
-- vim.pack stashes local changes before it checks out a new revision and never
-- pops them, so a plugin we patch locally comes back as upstream with the
-- change silently inactive.
--
-- vim-test indexes an Nx project.json for "name" without checking the key is
-- there, which aborts the test command in a project that omits it; patched, it
-- falls back to workspace.json. The patch file is what an install has to apply,
-- since a machine cloning this config has no stash to restore from.
local local_patches = {
  ['vim-test'] = vim.fn.stdpath('config') .. '/vim-test-nx-local.patch',
}

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack_local_patches', {}),
  callback = function(ev)
    local git = function(...)
      return vim.system({ 'git', '-C', ev.data.path, ... }, { text = true }):wait()
    end
    local warn = function(msg)
      vim.notify('vim.pack: ' .. msg, vim.log.levels.WARN)
    end

    if ev.data.kind == 'update' then
      -- Restore only the stash this update took. An older one is work someone
      -- parked deliberately, and reviving it unasked would be a surprise.
      -- Popping keeps any local edit beyond the patch file and leaves no stash
      -- behind, so `git stash list` in the plugin stays empty.
      -- git prefixes the message it was given with "On <branch>:", and vim.pack
      -- keeps plugins on a detached HEAD, so the subject reads
      -- "On (no branch): vim.pack: <timestamp> Stash before checkout".
      local top = git('stash', 'list', '--max-count=1', '--format=%gs').stdout or ''
      if not top:find('vim%.pack: .* Stash before checkout') then
        return
      end
      if git('stash', 'pop', '--quiet').code == 0 then
        return
      end
      -- A conflicted pop writes markers into the plugin's source, breaking it
      -- outright. Discard that and leave the stash, which still holds the change.
      git('checkout', '--', '.')
      warn(('%s has local changes that no longer apply; they are in its git stash')
        :format(ev.data.spec.name))
    elseif ev.data.kind == 'install' then
      local patch = local_patches[ev.data.spec.name]
      if patch ~= nil then
        local res = git('apply', patch)
        if res.code ~= 0 then
          warn(('could not apply %s\n%s'):format(patch, res.stderr))
        end
      end
    end
  end,
})

local gh = function(repo, opts)
  return vim.tbl_extend('error', { src = 'https://github.com/' .. repo }, opts or {})
end

vim.pack.add({
  -- Files and navigation
  gh('justinmk/vim-dirvish'),
  gh('tpope/vim-eunuch'),
  gh('ctrlpvim/ctrlp.vim'),
  gh('mileszs/ack.vim'),
  gh('junegunn/fzf'),

  -- Editing
  gh('tpope/vim-commentary'),
  gh('tpope/vim-repeat'),
  gh('tpope/vim-surround'),
  gh('wellle/targets.vim'),
  gh('michaeljsmith/vim-indent-object'),
  gh('junegunn/vim-easy-align'),
  gh('chaoren/vim-wordmotion'),
  gh('bronson/vim-trailing-whitespace'),
  gh('haya14busa/incsearch.vim'),
  gh('vim-scripts/vis'),
  -- Render ANSI escape sequences as colours
  gh('vim-scripts/AnsiEsc.vim'),

  -- Git
  gh('tpope/vim-fugitive'),
  gh('airblade/vim-gitgutter'),

  -- Interface
  gh('vim-airline/vim-airline'),
  gh('vim-airline/vim-airline-themes'),
  gh('junegunn/limelight.vim'),

  -- Colour. Ships both scheme families, named base16-<name> and
  -- base24-<name>; set_theme.vim writes the base16-<name> form.
  gh('tinted-theming/tinted-vim'),

  -- Sessions
  gh('xolox/vim-misc'),
  gh('xolox/vim-session'),

  -- tmux
  gh('tmux-plugins/vim-tmux'),
  gh('benmills/vimux'),

  -- Tests. Carries a local patch, restored by the PackChanged hook above.
  gh('vim-test/vim-test'),

  -- Per-directory config, whitelisted to ~/salemove further down
  gh('LucHermitte/lh-vim-lib'),
  gh('LucHermitte/local_vimrc'),

  -- Language servers and completion
  gh('neoclide/coc.nvim', { version = 'release' }),
  gh('neovim/nvim-lspconfig'),

  -- Languages. Nvim's runtime ships no elixir syntax, so vim-elixir is what
  -- highlights the language we work in, heex included.
  gh('elixir-editors/vim-elixir'),
  gh('fatih/vim-go'),
  gh('vmchale/dhall-vim'),
  gh('pearofducks/ansible-vim'),
  gh('vim-scripts/HTML-AutoCloseTag'),
  gh('hail2u/vim-css3-syntax'),
  gh('tpope/vim-haml'),
  gh('keith/swift.vim'),
  gh('artur-shaik/vim-javacomplete2'),

  -- Scheme, Clojure and other Lisp-y things
  gh('guns/vim-sexp'),
  gh('tpope/vim-sexp-mappings-for-regular-people'),
  gh('kien/rainbow_parentheses.vim'),
  gh('jpalardy/vim-slime'),
  gh('guns/vim-clojure-static'),
  gh('guns/vim-clojure-highlight'),
  gh('tpope/vim-fireplace'),
  gh('tpope/vim-classpath'),
})
EOF

filetype plugin indent on

augroup dirvish_config
  autocmd!
  autocmd FileType dirvish nmap - <plug>(dirvish_up)
augroup END

map <silent> - :Dirvish<CR>

" Set up bindings for sub-word motions
let g:wordmotion_prefix = ','

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
set nowritebackup
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
if exists('$BASE16_THEME')
    \ && (!exists('g:colors_name')
    \ || g:colors_name != 'base16-$BASE16_THEME')
  " let base16colorspace=256
  colorscheme base16-$BASE16_THEME

  " Airline
  " let g:airline_theme = 'base16_$BASE16_THEME'
  let g:airline_theme = 'base16_' . substitute($BASE16_THEME, "-", "_", "")
else
  " set background=light
  " colorscheme base16-summerfruit-light
  " set background=dark
  " colorscheme base16-3024

  " Airline
  " let g:airline_theme = 'base16_summerfruit_light'
  " let g:airline_theme = 'base16_3024'
endif
if filereadable(expand("$HOME/.config/tinted-theming/set_theme.vim"))
  " let base16colorspace=256
  source $HOME/.config/tinted-theming/set_theme.vim
  let g:airline_theme = substitute(substitute(execute('colorscheme'), "-", "_", "g"), '\n', "", "")
endif

" A theme switched elsewhere (the base16_* shell aliases) only rewrites
" set_theme.vim; nothing in that path reaches an editor that is already
" running. Re-read the file when the pane regains focus, which is how a theme
" changed in another pane arrives here. Needs `focus-events on` in tmux.
" While the theme name is unchanged the sourced file short-circuits before it
" applies the colorscheme, and comparing g:colors_name keeps AirlineTheme from
" running, so an ordinary focus change repaints nothing.
function! s:ReloadBase16Theme() abort
  let l:path = expand("$HOME/.config/tinted-theming/set_theme.vim")
  if !filereadable(l:path)
    return
  endif
  let l:before = get(g:, 'colors_name', '')
  execute 'source' l:path
  if get(g:, 'colors_name', '') ==# l:before
    return
  endif
  " g:airline_theme is only consulted while airline loads, so a statusline that
  " is already up needs the command. vim-airline-themes ships far fewer base16
  " themes than tinted-shell has schemes, so a missing one stays quiet rather
  " than throwing on every theme switch.
  if exists(':AirlineTheme') == 2
    silent! execute 'AirlineTheme'
      \ substitute(substitute(execute('colorscheme'), "-", "_", "g"), '\n', "", "")
  endif
endfunction

command! Base16Reload call s:ReloadBase16Theme()

augroup base16_live_reload
  autocmd!
  autocmd FocusGained * call s:ReloadBase16Theme()
augroup END

set mousemodel=popup
" Disable mouse selection entering the Visual mode
"set mouse-=a
" But I need mouse=a for scolling to work in tmux
set mouse=a
set nocursorline
" set guioptions=egmrti
set gfn=Monospace\ 10

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

" vim-airline
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

"" Haskell
augroup vimrc-haskell
  autocmd!
  autocmd FileType haskell setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
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
" noremap <Leader>ga :Gwrite<CR>
" " Make the default commit binding be verbose
" noremap <Leader>gc :Git commit -v<CR>
" noremap <Leader>gsh :Git push<CR>
" noremap <Leader>gll :Git pull<CR>
" noremap <Leader>gs :Git status<CR>
" noremap <Leader>gb :Git blame<CR>
" noremap <Leader>gd :Gvdiff<CR>
" noremap <Leader>gr :Git remove<CR>
noremap <Leader>gl :Git log --stat<CR>
noremap <Leader>vgl :vert Git log --stat<CR>
noremap <Leader>glg :vert Git log --topo-order --graph --pretty=format:'%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n'<CR>
" Remap hunk staging etc to not clash with split navigation's <leader>h
"GitGutterStageHunk
nmap <leader>cs <Plug>(GitGutterStageHunk)
nmap <leader>cp <Plug>(GitGutterPreviewHunk)
nmap <leader>cr <Plug>(GitGutterRevertHunk)
nmap <leader>cu <Plug>(GitGutterUndoHunk)

" session management
" nnoremap <leader>so :OpenSession
" nnoremap <leader>ss :SaveSession
" nnoremap <leader>sd :DeleteSession<CR>
" nnoremap <leader>sc :CloseSession<CR>

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

let g:ctrlp_use_caching = 0
let g:ctrlp_user_command_async = 1

if executable('rg')
  " https://github.com/BurntSushi/ripgrep
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ackprg = 'rg --vimgrep --smart-case'
elseif executable('ag')
  " https://github.com/ggreer/the_silver_searcher
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ackprg = 'ag --vimgrep --smart-case'
else
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
endif

nnoremap <C-f> :LAck!<SPACE>
nnoremap <leader>f :LAck! <C-R><C-W>
" yank the current visual selection and insert it as the search term
vnoremap <leader>f y:<C-u>LAck! "<C-r>0"<space>

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
augroup END


let g:javascript_enable_domhtmlcss = 1

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
" nmap <leader>gr :checktime<CR>

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

"" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
vmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Highlight 121st column if text flows over it
highlight ColorColumn ctermbg=red guibg=#ed2939
call matchadd('ColorColumn', '\%121v', 100)

set spelllang=en_us
set spellfile=~/.config/nvim/spell/mydict.utf-8.add

augroup text
  autocmd!
  au FileType gitcommit,markdown setlocal spell
augroup END

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

augroup vimrc-java
  autocmd!
  au FileType java setlocal omnifunc=javacomplete#Complete
augroup END



"" Coc settings
" Give more space for displaying messages.
" set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
" XXX Shouldn't be required if the autgroup below has all the necessary
" languages
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup coc-group
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType haskell,dhall,elm setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" XXX conflicts with LAck <C-f> bindings
" if has('nvim-0.4.0') || has('patch-8.2.0750')
"   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

nmap <leader>cl  <Plug>(coc-codelens-action)


" Mappings for CoCList
" " Show all diagnostics.
" nnoremap <silent><nowait> <leader>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
" nnoremap <silent><nowait> <leader>e  :<C-u>CocList extensions<cr>
" " Show commands.
" nnoremap <silent><nowait> <leader>c  :<C-u>CocList commands<cr>
" " Find symbol of current document.
nnoremap <silent><nowait> go  :<C-u>CocList outline<cr>
" " Search workspace symbols.
nnoremap <silent><nowait> gs  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent><nowait> <leader>p  :<C-u>CocListResume<CR>

call lh#local_vimrc#munge('whitelist', $HOME.'/salemove')

function! GetVisualSelection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

vmap gpr :s/\%V.*\%V./\=system(['git', 'show', '-s', '--date=short', '--pretty=format:%h ("%s", %ad)', trim(GetVisualSelection())])/<CR>:noh<CR>
nmap <expr> gpr GitPrettyRef()

function GitPrettyRef(type = '') abort
  if a:type == ''
    set opfunc=GitPrettyRef
    return 'g@'
  endif

  let sel_save = &selection
  let reg_save = getreginfo('"')
  let cb_save = &clipboard
  let visual_marks_save = [getpos("'<"), getpos("'>")]

  try
    let commands = #{line: "'[V']", char: "`[v`]", block: "`[\<c-v>`]"}
    silent exe 'noautocmd keepjumps normal ' .. get(commands, a:type, '') .. 'gpr'
  finally
    call setreg('"', reg_save)
    call setpos("'<", visual_marks_save[0])
    call setpos("'>", visual_marks_save[1])
    let &clipboard = cb_save
    let &selection = sel_save
  endtry
endfunction

lua require('config')
