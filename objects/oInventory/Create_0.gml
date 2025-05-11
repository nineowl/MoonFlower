height= 200;
width =240;


op_border = 8;
op_space = 16;

option[0] = "|FLWR|"
option[1] = "| USE|";
option[2] = "| KEY|";
option[3] = "|GAME|";

op_length = array_length(option);


pos = 0;
game_pos = 0;


pg_border = 24;

info_flwr[0] = "Petals: ";
info_flwr[1] = "Stem Type: ";
info_flwr[2] = "Description: ";
info_flwr_length = array_length(info_flwr);


info_game[0] = "Settings";
info_game[1] = "Quit";
info_game_length = array_length(info_game);

flwr_pos=0;
max_flwr=1;


controlsSetup();

visible = false;