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

//Sprites
maskSpr=sPlayerIdle;
idleSpr=sPlayerIdle;
walkSpr=sPlayerWalk;
runSpr=sPlayerRun;
jumpSpr=sPlayerJump;

//Moving
face = 1; //-1 left, 1 right
moveDir = 0; //-1 left, 0, 1 right
runType = 0;
moveSpd[0] = 2;
moveSpd[1] = 3.5;
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
		jspd[0] =  -2.85;
		jumpHoldFrames[1]=10;
		jspd[1] =  -1.85;
		
	//Coyote Time
	//Hang Time
	coyoteHangFrames=3;
	coyoteHangTimer=0;
	//Jump buffer time
	coyoteJumpFrames=6;
	coyoteJumpTimer=0;
