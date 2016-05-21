let s:save_cpo = &cpo "{{{
set cpo&vim "}}}

command! -range ShellcheckSuppressWarnings :<line1>,<line2>call shellcheck#SuppressWarnings(); :w

let &cpo = s:save_cpo "{{{
unlet s:save_cpo "}}}
