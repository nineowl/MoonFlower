function controlsSetup(){
	jumpBufferTime=3;
	jumpKeyBuffered=0;
	jumpKeyBufferTimer=0;
}

function getControls(){
	//Direction Inputs
	rightKey = keyboard_check((ord("D"))) + gamepad_button_check(0,gp_padr);
		rightKey = clamp(rightKey,0,1);
	leftKey = keyboard_check((ord("A"))) + gamepad_button_check(0,gp_padl);
		leftKey = clamp(leftKey,0,1);
	
	
	//Action Inputs
	jumpKeyPressed = keyboard_check_pressed(vk_space) + gamepad_button_check_pressed(0, gp_face1);
		jumpKeyPressed = clamp(jumpKeyPressed,0,1);
	jumpKey = keyboard_check(vk_space) + gamepad_button_check(0, gp_face1);
		jumpKey = clamp(jumpKey,0,1);
		
	//Jump Key Buffering
	if jumpKeyPressed{
		jumpKeyBufferTimer =jumpBufferTime;
	}
	if jumpKeyBufferTimer>0{
		jumpKeyBuffered=1;
		jumpKeyBufferTimer--;
	}else{
		jumpKeyBuffered=0;
	}
	

}