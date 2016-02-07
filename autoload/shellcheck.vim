function! shellcheck#SuppressWarnings()
  let codes = {}
  try
    let cur_messages = b:syntastic_private_messages[line(".")]
  catch
    let cur_messages = []
  endtry
  for message in cur_messages
    let code = matchstr(message.text, '\[\zsSC[0-9]\+\ze\]$', 0, 1)
    let codes[code] = message.text
  endfor

  let suppressCodes = []
  for code in keys(codes)
    " let ret = input(codes[code]." <- Suppress? [Y/n]: ")
    let ret = "y"
    if tolower(ret[0]) != "n"
      let suppressCodes = add(suppressCodes, code)
    endif
  endfor

  if !empty(suppressCodes)
    let prev_lineno = line(".") - 1
    let prev_line = getline(prev_lineno)
    if matchstr(prev_line, "#.*shellcheck") == ""
      let newline = getline(".")[0:(indent(".")-1)] ."# shellcheck disable=". join(suppressCodes, ",")
      call append(prev_lineno, newline)
    else
      let line_parse = matchlist(prev_line, '\(.*#.*shellcheck.*\)\(\sdisable=\)\([SC0-9,]*\)\(.*\)')
      let line_head = line_parse[1]
      let line_code = line_parse[3]
      let line_tail = line_parse[4]
      let currrent_disable_codes = split(line_code, ",")
      if !empty(currrent_disable_codes)
        let suppressCodes = uniq(sort(extend(suppressCodes, currrent_disable_codes)))
      endif
      let newline = line_head ." disable=". join(suppressCodes, ",") . line_tail
      call setline(prev_lineno, newline)
    endif
  endif
endfunction
