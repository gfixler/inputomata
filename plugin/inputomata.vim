if exists("g:loaded_inputomata") || v:version < 700 || &cp
  finish
endif
let g:loaded_inputomata = 1

function! Inputomata(state_machine)
    call inputomata#launch_fsm(a:state_machine)
endfunction

