getControls();

if(instance_exists(oPlayer))max_flwr= array_length(oPlayer.inventory);

if (enterKeyPressed){
	if(visible){
		visible = false
	} else {
		visible = true;
	}

}

if (visible){


	pos += cycleRightKeyPressed-cycleLeftKeyPressed;

	if (pos<0) pos=op_length-1;
	if (pos>=op_length) pos=0;



	


















}