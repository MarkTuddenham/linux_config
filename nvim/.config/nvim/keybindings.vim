noremap <leader>h <cmd>noh<cr>

" " Copy to clipboard
" vnoremap  <leader>y  "+y<cr>
" nnoremap  <leader>Y  "+yg_<cr>
" nnoremap  <leader>y  "+y<cr>

" Paste from clipboard
nnoremap <leader>p "+p<cr>
nnoremap <leader>P "+P<cr>
vnoremap <leader>p "+p<cr>
vnoremap <leader>P "+P<cr>

" Keep flags when reusing substitution
nnoremap & :&&<cr>
xnoremap & :&&<cr>

" Better navigation with next (keeps cursor on one line)
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" More undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
inoremap ( (<c-g>u
inoremap ) )<c-g>u

" Jump list mutations
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Better text moving
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv
" inoremap <c-j> <esc>:m .+1<cr>==
" inoremap <c-k> <esc>:m .-2<cr>==
" nnoremap <leader>j :m .+1<cr>==
" nnoremap <leader>k :m .-2<cr>==

" delete
nnoremap dl d0D

nnoremap <silent> <C-f> :silent !tmux neww tmux-sessioniser<cr>

" " CoPilot
" imap <silent><script><expr> <C-y> copilot#Accept("\<CR>")
" let g:copilot_no_tab_map = v:true


