/*****Controls related *****/
/*Gamepad Related */
gamepads = [];
gamepad_main = 0;



function controlsSetup(){
	jumpBufferTime=3;
	jumpKeyBuffered=0;
	jumpKeyBufferTimer=0;
}

function getControls(){
	//Direction Inputs
	rightKey = keyboard_check((ord("D"))) + gamepad_button_check(global.gamepad_main,gp_padr);
		rightKey = clamp(rightKey,0,1);
	leftKey = keyboard_check((ord("A"))) + gamepad_button_check(global.gamepad_main,gp_padl);
		leftKey = clamp(leftKey,0,1);
	downKey = keyboard_check((ord("S"))) + gamepad_button_check(global.gamepad_main,gp_padd);
		downKey = clamp(downKey,0,1);
	upKey = keyboard_check((ord("W"))) + gamepad_button_check(global.gamepad_main,gp_padu);
		upKey = clamp(upKey,0,1);
	
	downKeyPressed = keyboard_check_pressed((ord("S"))) + gamepad_button_check_pressed(global.gamepad_main,gp_padd);
		downKeyPressed = clamp(downKeyPressed,0,1);
	upKeyPressed = keyboard_check_pressed((ord("W"))) + gamepad_button_check_pressed(global.gamepad_main,gp_padu);
		upKeyPressed = clamp(upKeyPressed,0,1);
	
	
	//Action Inputs
	jumpKeyPressed = keyboard_check_pressed(vk_space) + gamepad_button_check_pressed(global.gamepad_main, gp_face1);
		jumpKeyPressed = clamp(jumpKeyPressed,0,1);
	jumpKey = keyboard_check(vk_space) + gamepad_button_check(global.gamepad_main, gp_face1);
		jumpKey = clamp(jumpKey,0,1);
		
	agileKey = keyboard_check(vk_lshift)+gamepad_button_check(global.gamepad_main,gp_face2);
		agileKey = clamp(agileKey,0,1);
	agileKeyPressed = keyboard_check_pressed(vk_lshift)+gamepad_button_check_pressed(global.gamepad_main,gp_face2);
		agileKeyPressed = clamp(agileKeyPressed,0,1);
		
		
		
	attackKey = keyboard_check(ord("N"))+gamepad_button_check(global.gamepad_main,gp_face3);
		attackKey = clamp(attackKey,0,1);
	attackKeyPressed = keyboard_check_pressed(ord("N"))+gamepad_button_check_pressed(global.gamepad_main,gp_face3);
		attackKeyPressed = clamp(attackKeyPressed,0,1);
		
	interactKey = keyboard_check(ord("J"))+gamepad_button_check(global.gamepad_main,gp_face4);
		interactKey = clamp(interactKey,0,1);
	interactKeyPressed = keyboard_check_pressed(ord("J"))+gamepad_button_check_pressed(global.gamepad_main,gp_face4);
		interactKeyPressed = clamp(interactKeyPressed,0,1);
		
	//agileKeyPressed = keyboard_check_pressed(ord("M"));
		
	
	//Menu Inputs
	enterKey = keyboard_check(vk_enter) + gamepad_button_check(global.gamepad_main,gp_start);
		enterKey = clamp(enterKey,0,1);
	enterKeyPressed = keyboard_check_pressed(vk_enter) + gamepad_button_check_pressed(global.gamepad_main,gp_start);
		enterKeyPressed = clamp(enterKeyPressed,0,1);
		
	
	cycleRightKey = keyboard_check(221) + gamepad_button_check(global.gamepad_main,gp_shoulderr);
		cycleRightKey = clamp(cycleRightKey,0,1);
	cycleRightKeyPressed = keyboard_check_pressed(221) + gamepad_button_check_pressed(global.gamepad_main,gp_shoulderr);
		cycleRightKeyPressed = clamp(cycleRightKeyPressed,0,1);
	cycleLeftKey = keyboard_check(219) + gamepad_button_check(global.gamepad_main,gp_shoulderl);
		cycleLeftKey = clamp(cycleLeftKey,0,1);
	cycleLeftKeyPressed = keyboard_check_pressed(219) + gamepad_button_check_pressed(global.gamepad_main,gp_shoulderl);
		cycleLeftKeyPressed = clamp(cycleLeftKeyPressed,0,1);
		
	menuRightKey = keyboard_check(vk_right) + gamepad_button_check(global.gamepad_main,gp_shoulderr);
		menuRightKey = clamp(menuRightKey,0,1);
	menuLeftKey = keyboard_check(vk_left) + gamepad_button_check(global.gamepad_main,gp_shoulderl);
		menuLeftKey = clamp(menuLeftKey,0,1);
	menuDownKey = keyboard_check(vk_down) + gamepad_button_check(global.gamepad_main,gp_padd);
		menuDownKey = clamp(menuDownKey,0,1);
	menuUpKey = keyboard_check(vk_up) + gamepad_button_check(global.gamepad_main,gp_padu);
		menuUpKey = clamp(menuUpKey,0,1);
		
		
	menuRightKeyPressed = keyboard_check_pressed(vk_right) + gamepad_button_check_pressed(global.gamepad_main,gp_shoulderr);
		menuRightKeyPressed = clamp(menuRightKeyPressed,0,1);
	menuLeftKeyPressed = keyboard_check_pressed(vk_left) + gamepad_button_check_pressed(global.gamepad_main,gp_shoulderl);
		menuLeftKeyPressed = clamp(menuLeftKeyPressed,0,1);
	menuDownKeyPressed = keyboard_check_pressed(vk_down) + gamepad_button_check_pressed(global.gamepad_main,gp_padd);
		menuDownKeyPressed = clamp(menuDownKeyPressed,0,1);
	menuUpKeyPressed = keyboard_check_pressed(vk_up) + gamepad_button_check_pressed(global.gamepad_main,gp_padu);
		menuUpKeyPressed = clamp(menuUpKeyPressed,0,1);
	
	
	
		
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