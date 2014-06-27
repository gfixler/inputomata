if exists("g:loaded_inputomata") || v:version < 700 || &cp
  finish
endif
let g:loaded_inputomata = 1

command! InputomataShiny call inputomata#examples#color#shiny()
command! InputomataAmazing call inputomata#examples#amazing#amaze_me()

