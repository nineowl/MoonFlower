//Custom functions for player
function setOnGround(_val=true){
	if _val==true{
		onGround=true;
		coyoteHangTimer=coyoteHangFrames;
	}else{
		onGround=false;
		coyoteHangTimer=0;
	}
}

//control setup
controlsSetup();

//Moving
moveDir = 0; //-1 left, 0, 1 right
moveSpd = 2;
xspd = 0;
yspd = 0;

	//Jumping
	grav = .275;
	termVel = 4;
	onGround=true;
	jumpMax=2;
	jumpCount=0;
	jumpHoldTimer=0;
		//Jump values for each successive jump
		jumpHoldFrames[0]=18;
		jspd[0] =  -3.15;
		jumpHoldFrames[1]=10;
		jspd[1] =  -2.85;
		
	//Coyote Time
	//Hang Time
	coyoteHangFrames=3;
	coyoteHangTimer=0;
	//Jump buffer time
	coyoteJumpFrames=6;
	coyoteJumpTimer=0;
