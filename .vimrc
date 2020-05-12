" no need to be vi-compatible
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM/NEOVIM COMPATIBILITY                                                     "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !has('nvim')
" enable default nvim behaviour in normal vim
	" backup directories
	set backupdir=~/.vim/backup//,.
	set directory=~/.vim/backup//,.
	set undodir=~/.vim/backup//,.

	" mouse
	set ttymouse=xterm2

	" enable statusline
	set laststatus=2

	" highlight searches
	set hlsearch
	set incsearch

	" indentation
	filetype plugin indent on
	set autoindent
	set smarttab

	" matchit plugin is enabled by default in neovim
	runtime macros/matchit.vim

	" loads of other stuff from https://neovim.io/doc/user/vim_diff.html
	set autoread                   " reread file if modified externally
	set backspace=indent,eol,start " enable backspace over whitespace
	set belloff=all                " no ringing bell please
	set cscopeverbose              " no clue
	set display=lastline           " display settings
	set encoding=utf-8             " default encoding utf-8
	set formatoptions=tcqj         " will be overwritten by ftdetect
	set nofsync                    " don't call OS fsync for efficiency
	set history=10000              " max history
	set langnoremap                " some map shenanigans
	set nolangremap                " langnoremap but better
else
" nvim-specific configuration
	set inccommand=nosplit
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" APPEARANCE                                                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" use my colorscheme
colorscheme thewursttheme

" interface settings
set number                               " show line numbers
set foldcolumn=1                         " show fold column
let &colorcolumn=join(range(81,81),",")  " highlight column 81
set lcs=tab:>\ \|,trail:+,nbsp:X,space:· " whitespace settings
set list                                 " show whitespace

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BEHAVIOUR                                                                    "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" turn on undofiles
set undofile

" enable mouse in any mode
set mouse=a

" add copy / paste using \y \p by using + (clipboard) as yank/paste register
" Ubuntu vim doesn't seem to be compiled with xterm_clipboard :(
" Check with :version
noremap <Leader>y "+y
noremap <Leader>p "+p

" add indentation settings
set smartindent   " smart indentation
set noexpandtab   " use hard tabs
set tabstop=4     " hard tab width of 4
set softtabstop=4 " soft tab width of 4
set shiftwidth=0

" auto wrap after 80 columns
set textwidth=80

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS                                                                      "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" get vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/0.10.0/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" list of vim-plug plugins
call plug#begin('~/.vim/plugged')
	if has('nvim') " neovim plugins
		" firenvim for Firefox integration
		Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
	else " vim plugins
	endif

	" common plugins
	Plug 'octol/vim-cpp-enhanced-highlight'
	Plug 'godlygeek/tabular' " :Tab
call plug#end()

" run default neovim plugins for vim
if !has('nvim')
endif

" custom command for aligning by spaces
command -range Align <line1>,<line2>s/\s\+/ /g | noh | <line1>,<line2>Tab/ /l0

" firenvim configuration
let g:firenvim_config = { 'localSettings': { '.*': { 'takeover': 'never' } } }
	" don't let firenvim takeover by default
if exists('g:started_by_firenvim')
	set laststatus=0     " disable statusline
	set nonumber         " don't show line numbers
	set foldcolumn=0     " don't show fold column
	set nolist           " don't show whitespace
	set background=light " light background
	au BufEnter github.com_*.txt set filetype=markdown " use markdown on GitHub

	" delayed write from https://github.com/glacambre/firenvim
	" write every 1000 ms
	let g:dont_write = v:false
	function! My_Write(timer) abort
		let g:dont_write = v:false
		write
	endfunction
	function! Delay_My_Write() abort
		if g:dont_write
			return
		end
		let g:dont_write = v:true
		call timer_start(1000, 'My_Write')
	endfunction
	au TextChanged * ++nested call Delay_My_Write()
	au TextChangedI * ++nested call Delay_My_Write()
	set autowriteall " write upon quit
endif
