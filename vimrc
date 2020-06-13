" File              : vimrc
" Author            : jose.felip@tandeltasystems.com
" Date              : 03.06.2019
" Last Modified Date: 03.06.2019
" Last Modified By  : jose.felip@tandeltasystems.com
" File              : vimrc
" Date              : 03.06.2019
" Last Modified Date: 03.06.2019
" File              : vimrc
" Date              : 03.06.2019
" Last Modified Date: 03.06.2019
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

"behave xterm
filetype off
set shell=bash
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup fedora
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add $PWD/cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     "set t_Sb= [4%dm
     "set t_Sf= [3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"


execute pathogen#infect()
filetype off
map <F2> :bp<RETURN>
map <F3> :bn<RETURN>

map <F5> :!AStyle % --style=otbs -s4 -p -k3 -W3 -xe -j -Oo -xC120 *.c *.h<RETURN>
map <F6> :NERDTree<CR>
map <F7> :TagbarToggle<CR>
map <S-F7> :!ctags.exe % -R<RETURN> "latest modification!
map <F8> [m
map <F9> ]m
nnoremap <F10> <C-w><C-o>
map <F12> :bd<RETURN>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

:nmap <S-p> :pu<CR>
:nnoremap gr :grep <cword> *<CR>
:nnoremap Gr :grep <cword> %:p:h/*<CR>
:nnoremap gR :grep '\b<cword>\b' *<CR>
:nnoremap GR :grep '\b<cword>\b' %:p:h/*<CR>


:set listchars=eol:_,tab:>-,trail:~,extends:>,precedes:<
:set list
:set colorcolumn=80

"set diffexpr=MyDiff()
"function MyDiff()
"  let opt = '-a --binary '
"  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
"  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
"  let arg1 = v:fname_in
"  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
"  let arg2 = v:fname_new
"  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
"  let arg3 = v:fname_out
"  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
"  let eq = ''
"  if $VIMRUNTIME =~ ' '
"    if &sh =~ '\<cmd'
"      let cmd = '""' . $VIMRUNTIME . '\diff"'
"      let eq = '"'
"    else
"      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
"    endif
"  else
"    let cmd = $VIMRUNTIME . '\diff'
"  endif
"  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
"endfunction

nnoremap <S-F11> :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
    let @/ = ''
    if exists('#auto_highlight')
        au! auto_highlight
        augroup! auto_highlight
        setl updatetime=4000
        echo 'Highlight current word: off'
        return 0
    else
        augroup auto_highlight
            au!
            au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
        augroup end
        setl updatetime=500
        echo 'Highlight current word: ON'
        return 1
    endif
endfunction


function! InsertDoxSource()
    return
        \  "/*! \r"
        \. "@file      \r"
        \. "@bief      \r"
        \. "@author    Jose.Felip@tandeltasystems.com\r"
        \. "@date      \r"
        \. "@copyright Tan Delta Systems Ltd.\r"
        \. "\r"
endfunction
iabbrev <expr> source# InsertDoxSource()


function! InsertDoxHeader()
    return
        \  "/*! \r"
        \. "@file      \r"
        \. "@bief      \r"
        \. "@detail    \r"
        \. "@example   \r"
        \. "@author    Jose.Felip@tandeltasystems.com\r"
        \. "@date      \r"
        \. "@version   \r"
        \. "@copyright Tan Delta Systems Ltd.\r"
        \. "\r"
endfunction
iabbrev <expr> header# InsertDoxHeader()

nnoremap <F9> :call<SID>LongLineHLToggle()<cr>
hi OverLength ctermbg=none cterm=none
match OverLength /\%>80v/
fun! s:LongLineHLToggle()
 if !exists('w:longlinehl')
  let w:longlinehl = matchadd('ErrorMsg', '.\%>80v', 0)
  echo "Long lines highlighted"
 else
  call matchdelete(w:longlinehl)
  unl w:longlinehl
  echo "Long lines unhighlighted"
 endif
endfunction

augroup myvimrc
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
augroup END

if exists('$TMUX')
    " tmux will only forward escape sequences to the terminal if surrounded by a DCS sequence
    let &t_SI .= "\<Esc>Ptmux;\<Esc>\<Esc>[3 q\<Esc>\\"
    let &t_EI .= "\<Esc>Ptmux;\<Esc>\<Esc>[1 q\<Esc>\\"
    autocmd VimLeave * silent !echo -ne "\033Ptmux;\013\033[0 q\033\\"
else
    let &t_SI .= "\<Esc>[3 q"
    let &t_EI .= "\<Esc>[1 q"
    autocmd VimLeave * silent !echo -ne "\033[0 q"
endif


:set fdm=syntax
:set sw=4
:set ts=4
:set et
:set cursorline
syntax on
