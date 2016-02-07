let s:save_cpo = &cpo
set cpo&vim

let s:bin = fnamemodify(resolve(expand('<sfile>:p')), ':h:h') . "/bin"
let s:wrapper_common = s:bin."/batscheck-wrapper.sh"
let s:wrapper_sh = s:bin."/bash"

function! batscheck#initBuffer()
  if (exists('b:batscheck_applied') && b:batscheck_applied)
    return
  endif
  let b:batscheck_applied = 1

  " shellcheck memo, it can not use these rule with batscheck.
  " SC1008: This shebang was unrecognized. Note that ShellCheck only handles sh/bash/ksh.
  " SC1091: Not following: <path/to/external>: openFile: does not exist (No such file or directory)
  for checker in [ 
        \ {"name":"bashate", "args":"", "args_append":""},
        \ {"name":"checkbashisms", "args":"", "args_append":""},
        \ {"name":"shellcheck", "args":"", "args_append":"-e SC1008,SC1091"}
        \ ]
    " replace checker_exec to wrapper
    let b:syntastic_sh_{checker.name}_exec = s:wrapper_common
    if exists("g:syntastic_sh_".checker.name."_exec")
      let b:syntastic_sh_{checker.name}_args = g:syntastic_sh_{checker.name}_exec
    else
      let b:syntastic_sh_{checker.name}_args = checker.name
    endif
    " Insert original checker to checker_args
    if (exists("g:syntastic_sh_".checker.name."_args") && checker.args == "")
      let b:syntastic_sh_{checker.name}_args .= " ".g:syntastic_sh_{checker.name}_args ." ". checker.args_append
    else
      let b:syntastic_sh_{checker.name}_args .= " ".checker.args ." ". checker.args_append
    endif
  endfor

  " sh_sh_checker special
  let b:shell = s:wrapper_sh

endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
