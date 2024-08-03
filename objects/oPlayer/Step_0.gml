//Get inputs
getControls();


//X Movement
	//Direction
	moveDir = rightKey - leftKey;

	//Get xspd
	xspd = moveDir * moveSpd;

	//X collision
	var _subPixel = .5;
	if place_meeting(x+xspd,y,oWall){
		//Scoot up to wall precisley
		var _pixelCheck = _subPixel * sign(xspd);
		while !place_meeting(x+_pixelCheck,y,oWall){
			x+=_pixelCheck;
		}
	
		//Set xpsd to zero to collide
		xspd=0;
	} 

	//Move
	x += xspd;

//Y Movement
	//Gravity
	if coyoteHangTimer>0{
		//count the timer down
		coyoteHangTimer--;  //is it possible we actually get 1 less frame because of where this is?
	}else{
		//Apply gravity to the player
		yspd+=grav;
		//We're no longer on the ground
		setOnGround(false);
	}
	
	
	//Rest/Prepare Jump Variables
	 if onGround{
		 jumpCount=0;
		 coyoteJumpTimer=coyoteJumpFrames;
	 }else{
		//if player is in the air make sure they can't do an extra jump
		coyoteJumpTimer--;
		if jumpCount==0&&coyoteJumpTimer<=0{jumpCount=1;};
	 }
	
	//initiate Jump
	if jumpKeyBuffered && jumpCount<jumpMax{
		
		//Reset Buffer
		jumpKeyBuffered=false;
		jumpKeyBufferTimer=0;
		
		//Increase the number of performed jumps;
		jumpCount++;
		//Set the jump hold timer
		jumpHoldTimer=jumpHoldFrames[jumpCount-1];
		//Tell ourself we're no longer on the ground
		setOnGround(false);
	}
	//Cut off the jump by releasing the button
	if !jumpKey{
		jumpHoldTimer=0;
	} 
	//Jump based on the time/holding the button
	if jumpHoldTimer>0{
		//constantly st the yspd to be jumping speed
		yspd = jspd[jumpCount-1];
		//count down timer
		jumpHoldTimer--;
	}
	
	
	//Terminal velocity
	if yspd>termVel{yspd=termVel;};
	
	//Y Collision
	var _subPixel=.5;
	if place_meeting(x,y+yspd,oWall){
		//Scoot up to the wall precisely
		var _pixelCheck = _subPixel * sign(yspd);
		while !place_meeting(x,y+_pixelCheck,oWall){
			y+=_pixelCheck;
		}
		//bonk code
		if yspd<0{
			jumpHoldTimer=0;
		}
		
		//Set yspd to 0 to collide
		yspd = 0;
		
	}
	//Set if on ground
	if yspd>=0 && place_meeting(x,y+1,oWall){
		setOnGround(true);
	} 
	
	
	//Move
	y+=yspd;
