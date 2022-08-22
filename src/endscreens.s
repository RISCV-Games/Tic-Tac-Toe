PLAYER_WIN_SCREEN:
  la a0, MenuGanhou
  jal DRAW_MENU
  bne a0, zero, FINISH_END_SCREEN
  jal INIT
PLAYER_LOOSE_SCREEN:
  la a0, MenuPerdeu 
  jal DRAW_MENU
  bne a0, zero, FINISH_END_SCREEN
  jal INIT
PLAYER_DRAW_SCREEN:
  la a0, MenuEmpatou # Menu Data
  jal DRAW_MENU
  bne a0, zero, FINISH_END_SCREEN
  jal INIT

FINISH_END_SCREEN:
j FINISH_END_SCREEN
