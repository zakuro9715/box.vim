let s:save_cpo = &cpo
set cpo&vim

" unimplemented
let s:disable_unicode = get(g:, 'box_disable_unicode', '')

let s:idx_horizontal = 0
let s:idx_vertical = 1
let s:idx_top_left = 2
let s:idx_top_right = 3
let s:idx_bottom_left = 4
let s:idx_bottom_right = 5
let s:idx_unicode = 0
let s:idx_ascii = 1
let s:chars = [
  \['─', '│', '┌', '┐', '└', '┘'],
  \['-', '|', '+', '+', '+', '+'],
\]

function! s:FrameChar(idx) abort
  if s:disable_unicode
    return s:chars[s:idx_ascii][a:idx]
  else
    return s:chars[s:idx_unicode][a:idx]
  endif
endfunction

function! s:GetChar(x, y, box_x, box_y, box_width, box_height) abort
  let is_left   = a:x == a:box_x
  let is_right  = a:x == a:box_x + a:box_width + 1
  let is_top    = a:y == a:box_y
  let is_bottom = a:y == a:box_y + a:box_height + 1


  if is_top
    if is_left
      return s:FrameChar(s:idx_top_left)
    elseif is_right
      return s:FrameChar(s:idx_top_right)
    else
      return s:FrameChar(s:idx_horizontal)
    endif
  elseif is_bottom
    if is_left
      return s:FrameChar(s:idx_bottom_left)
    elseif is_right
      return s:FrameChar(s:idx_bottom_right)
    else
      return s:FrameChar(s:idx_horizontal)
    endif
  elseif is_left || is_right
    return s:FrameChar(s:idx_vertical)
  endif

  return ' '
endfunction

function! s:GetLineText(line, box_x, box_y, box_width, box_height) abort
  let fn = 's:GetChar(' . join(['v:val', a:line + a:box_y, a:box_x, a:box_y, a:box_width, a:box_height], ',') . ')'
  return join(map(range(a:box_x + a:box_width + 2), fn), '')
endfunction

function! s:InsertBoxFrame(x, y, width, height) abort
  let pos = getpos(".")
  let p = [a:x == -1 ? pos[0] : a:x, a:y == -1 ? pos[1] : a:y]

  call setpos(".", p)

  let fn = 's:GetLineText(' . join(['v:val', p[0], p[1], a:width, a:height], ',') . ') . "\n"'
  let text = join(map(range(a:height + 2), fn), '')
  execute ':normal i ' . text

  call setpos(".", pos)
endfunction

function! box#CmdBox(...) abort
  let width = 0
  let height = 0
  if a:0 == 1
    let width = a:1
    let height = a:1
  elseif a:0 == 2
    let width = a:1
    let height = a:2
  endif
  call s:InsertBoxFrame(-1, -1, width, height)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
