//get inputs
getControls();

//move through the menu
pos+= downKeyPressed-upKeyPressed;

if pos>=op_length{pos=0;};
if pos<0{pos=op_length-1;};

//using the options
if enterKey{
	switch(pos){
		//start game
		case 0:
			room_goto_next();
			break;
		//Settings
		case 1:
			break;
		//quit game
		case 2:
			game_end();
			break;
	

	}
}