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
	downKey = keyboard_check((ord("S"))) + gamepad_button_check(0,gp_padd);
		downKey = clamp(downKey,0,1);
	upKey = keyboard_check((ord("W"))) + gamepad_button_check(0,gp_padu);
		upKey = clamp(upKey,0,1);
	
	downKeyPressed = keyboard_check_pressed((ord("S"))) + gamepad_button_check_pressed(0,gp_padd);
		downKeyPressed = clamp(downKeyPressed,0,1);
	upKeyPressed = keyboard_check_pressed((ord("W"))) + gamepad_button_check_pressed(0,gp_padu);
		upKeyPressed = clamp(upKeyPressed,0,1);
	
	
	//Action Inputs
	jumpKeyPressed = keyboard_check_pressed(vk_space) + gamepad_button_check_pressed(0, gp_face1);
		jumpKeyPressed = clamp(jumpKeyPressed,0,1);
	jumpKey = keyboard_check(vk_space) + gamepad_button_check(0, gp_face1);
		jumpKey = clamp(jumpKey,0,1);
		
	runKey = keyboard_check(vk_lshift)+gamepad_button_check(0,gp_face3);
		runKey = clamp(runKey,0,1);
		
	attackKey = keyboard_check(ord("N"));
		attackKey = clamp(attackKey,0,1);
	attackKeyPressed = keyboard_check_pressed(ord("N"));
		attackKeyPressed = clamp(attackKeyPressed,0,1);
		
	interactKey = keyboard_check(ord("J"));
		interactKey = clamp(interactKey,0,1);
	interactKeyPressed = keyboard_check_pressed(ord("J"));
		interactKeyPressed = clamp(interactKeyPressed,0,1);
		
	
	//Menu Inputs
	enterKey = keyboard_check(vk_enter) + gamepad_button_check(0,gp_start);
		enterKey = clamp(enterKey,0,1);
	enterKeyPressed = keyboard_check_pressed(vk_enter) + gamepad_button_check_pressed(0,gp_start);
		enterKeyPressed = clamp(enterKeyPressed,0,1);
	
	
		
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