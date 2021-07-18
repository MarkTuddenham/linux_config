noremap <leader>h <cmd>noh<cr>

" Find files using leaderTelescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" " Copy to clipboard
vnoremap  <leader>y  "+y<cr>
nnoremap  <leader>Y  "+yg_<cr>
nnoremap  <leader>y  "+y<cr>

" " Paste from clipboard
nnoremap <leader>p "+p<cr>
nnoremap <leader>P "+P<cr>
vnoremap <leader>p "+p<cr>
vnoremap <leader>P "+P<cr>

