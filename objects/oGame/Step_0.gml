//Reset button
resetKey = keyboard_check(ord("R"));

if (resetKey){ game_restart();};

random_timer++;

if (random_timer>=random_time_limit){
	randomize();
	random_timer=0;
}