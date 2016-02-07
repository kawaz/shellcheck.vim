command! -range ShellcheckSuppressWarnings :<line1>,<line2>call shellcheck#SuppressWarnings(); :w
