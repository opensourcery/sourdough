" vim: foldmethod=marker
set ts=2 sw=2
"{{{ testing functions

" Uses matchit.vim's '[%' command to identify and return the 
" first line of the next enclosing group.  Returns '' if there
" is no enclosing group (we are at the root of the file (before/
" between any class or module definitions, for instance)
function! s:GetNextGroup()
  let current = getline(".")
  normal [%
  let next_group_line = getline(".")
  if current == next_group_line
    " no new group was found, so we are at the root
    return ''
  else
    return next_group_line
  endif
endfunction

" Requires matchit.vim's functionality.
" Walks backgrounds through group definitions surrounding the current line
" using '[%' in order to capture the scattered context/should descriptions
" required to build a Shoulda unit test case name.
function! s:BuildTestName()
  let should_regexp = 'should\s*"\([^"]\+\)"\s*do'
  let context_regexp = 'context\s*"\([^"]\+\)"\s*do'
  let class_regexp = 'class\s*\(\i\+\)Test\s*<\s*Test::Unit::TestCase'

  let test_name = ''
  let debug = []
  let test = []
  let class = ''
  let has_context = 0

  let group_line = s:GetNextGroup()
  while group_line != '' 

      let group = matchlist(group_line,class_regexp)
      if !empty(group) && group[1] != ''
        let class = group[1]
      else 
        let group = matchlist(group_line,context_regexp)
        if !empty(group) && group[1] != ''
          let has_context = 1
          let test = [group[1]] + test
        else
          let group = matchlist(group_line,should_regexp)
          if !empty(group) && group[1] != ''
            let test = ['should ' . group[1]] + test
          endif
        endif
      endif

      let debug += group
      let group_line = s:GetNextGroup()

  endwhile " any further groups?

  if !empty(test)
    let test_name = join(test, ' ')
    if has_context == 0
      let test_name = class . ' ' . test_name
    endif
    let test_name = 'test: ' . test_name . '. '
  endif 

  return test_name
endfunction

" Runs the test file in ruby, calling the test case the cursor is currently
" in.
function! s:CallTestCase()
  let orig_pos = getpos('.')
  let test_name = s:BuildTestName()
  call setpos('.', orig_pos)
  execute "!clear; echo '" . test_name . "'; ruby -Itest % --name='" . test_name . "'"
endfunction
"}}}
command! -nargs=0 Shoulda call s:CallTestCase()
" standard Test::Unit calls for a single test case
map <F7> ?def test<cr>w:nohlsearch<cr>:!clear; ruby -Itest % --name=<cword><cr>
imap <F7> <esc>?def test<cr>w:nohlsearch<cr>:!clear; ruby -Itest % --name=<cword><cr>
" Test::Unit calls using Shoulda syntax for a single test case
map <F8> :Shoulda<cr>
imap <F8> <esc>:Shoulda<cr>
" Run the whole test file
map <F9> :!clear; ruby -Itest %<cr>
imap <F9> <esc>:!clear; ruby -Itest %<cr>
