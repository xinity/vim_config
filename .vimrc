set exrc secure
"######################
"#		 plugins	  #
"######################

"airline
let g:airline_powerline_fonts = 1

"######################
"#		 personal	  #
"######################

"general
set backspace=indent,eol,start
set nocompatible
set encoding=utf-8
filetype on
filetype plugin indent on
let &path.="/src/include"
set lazyredraw
set ttyfast
set copyindent
set clipboard=unnamed

"splitting
set splitbelow splitright

"look of vim
set t_Co=256
colorscheme gruvbox
set background=dark
syntax on
set number

"hilight whitespaces
set list listchars=tab:\|·,trail:·
set autoindent smartindent

"filetype detection and set shiftwidth
function SetSw(index, length)
	if a:index<0
		let sw=4
	elseif a:index>=0 && a:index<a:length
		let sw=2
	endif
	execute "set tabstop=".sw
	execute "set softtabstop=".sw
	execute "set shiftwidth=".sw
	"is needed because NERDTREE will set modifiable off so every time you open
	"a new tab from NERDTREE an error ocours
	set modifiable
	if a:index==3
		set expandtab colorcolumn=81 textwidth=80 | retab.sw
	else
		set noexpandtab expandtab noexpandtab colorcolumn=81 textwidth=80 |
			\ retab!sw
	endif
endfunction

"call above function
let blacklist = ['html', 'css', 'json', 'yaml', 'cpp']
augroup all
	au BufRead,BufNewFile,BufNew *
		\ call SetSw(index(blacklist, &ft), len(blacklist))
	au BufRead,BufNewFile,BufNew *.asm set filetype=nasm
	au BufRead,BufNewFile,BufNew *.nix set filetype=yaml
	au BufRead,BufNewFile,BufNew *.pp	set filetype=puppet
augroup END

"commenting blocks of code, my native nerdcommenter replacement
augroup comments
	autocmd FileType c,cpp,java,scala let b:comment_leader = '//'
	autocmd FileType sh,ruby,python,yaml let b:comment_leader = '#'
	autocmd FileType conf,fstab let b:comment_leader = '#'
	autocmd FileType vim let b:comment_leader = '"'
augroup END

"netrw, my native nerdtree replacement
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
let g:netrw_altv = 1
let g:netrw_winsize = 25

"toggle Vexplore
function ToggleVExplorer()
	if exists("t:expl_buf_num")
		let expl_win_num = bufwinnr(t:expl_buf_num)
		if expl_win_num != -1
			let cur_win_nr = winnr()
			exec expl_win_num . 'wincmd w'
			close
			exec cur_win_nr . 'wincmd w'
			unlet t:expl_buf_num
		else
			unlet t:expl_buf_num
		endif
	else
		exec '1wincmd w'
		Vexplore
		let t:expl_buf_num = bufnr("%")
	endif
endfunction

"keymappings
let mapleader = "\<Space>"
inoremap jk <ESC>
nnoremap <silent> <Leader><Space> :call ToggleVExplorer()<CR>
nnoremap <silent> <S-u> :redo<CR>
nnoremap <Leader>t :tabnew 

"c development
nnoremap <silent> <F2> :make!<cr>
nnoremap <silent> <F3> :make! clean<cr>
nnoremap <silent> gf <C-W>gf
vnoremap <silent> gf <C-W>gf

"save file as root
cmap w!! w !sudo tee % >/dev/null

"split navigation
nnoremap <silent> <C-J> <C-W><C-J>
nnoremap <silent> <C-K> <C-W><C-K>
nnoremap <silent> <C-L> <C-W><C-L>
nnoremap <silent> <C-H> <C-W><C-H>
nnoremap <silent> <Leader>h :split<CR>
nnoremap <silent> <Leader>v :vsplit<CR>

"incsearch
map  /	<Plug>(incsearch-forward)
map  ?	<Plug>(incsearch-backward)
map  g/ <Plug>(incsearch-stay)

"writing
nnoremap <silent> <Leader>s :setlocal spell! spelllang=en_us<CR>

"commenting
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')
	\<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')
	\<CR>//e<CR>:nohlsearch<CR>

"######################
"#		 testing	  #
"######################

"serch/replace
:nnoremap <Leader>c :%s/\<<C-r><C-w>\>//g<Left><Left>
":nnoremap <Leader>c :set nohlsearch\|:call SubstituteAll()<CR>
:nnoremap <Leader>s :set nohlsearch\|:call HighlightAll()<CR>

function HighlightAll()
	let l:item = expand("<cword>")
	execute 'let @/ ="' . l:item .'"'
	set hlsearch
endfunction

"function SubstituteAll()
"	call HighlightAll()
"	let item = expand("<cword>")
"	let l:input = input('s/' . item . '/')
"	substitut(s,item,input,g)
"endfunction

