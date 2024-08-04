//Get inputs
getControls();


//X Movement
	//Direction
	moveDir = rightKey - leftKey;
	//Get my face
	if moveDir!=0{face=moveDir;};

	//Get xspd
	runType=runKey;
	xspd = moveDir * moveSpd[runType];

	//X collision
	var _subPixel = .5;
	if place_meeting(x+xspd,y,oWall){
		
		//First Check if there is a slope to go up
		if !place_meeting(x+xspd,y-abs(xspd)-1,oWall){  //the -1 is a little bit of padding
			while place_meeting(x+xspd,y,oWall){y-=_subPixel;};
		} else { //Next, check for ceiling slopes, otherwise, do a regular collision	
			//Ceiling Slopes
			if !place_meeting(x+xspd,y+abs(xspd)+1,oWall){
				while place_meeting(x+xspd,y,oWall){y+=_subPixel;};
			} else { //Normal X collision
				//Scoot up to wall preciseley
				var _pixelCheck = _subPixel * sign(xspd);
				while !place_meeting(x+_pixelCheck,y,oWall){x+=_pixelCheck;};
	
				//Set xpsd to zero to collide
				xspd=0;
			}
		}
	} 
	
	//Go Down Slops
	if yspd>=0 && !place_meeting(x+xspd,y+1,oWall) && place_meeting(x+xspd,y+abs(xspd)+1,oWall){
		while !place_meeting(x+xspd,y+_subPixel,oWall){y+=_subPixel;};
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
	
	//Y Collision and movement
	//Terminal velocity
	if yspd>termVel{yspd=termVel;};
	
	//Y Collision
	var _subPixel=.5;
	
	//Upwards Y Collision (with ceiling slopes)
	if yspd<0 && place_meeting(x,y+yspd,oWall){
		//jump into sloped ceilings
		var _slopeSlide=false;
		//Slide upleft slope
		if moveDir ==0 && !place_meeting(x-abs(yspd)-1,y+yspd,oWall){
			while place_meeting(x,y+yspd,oWall){x-=1;}; //use 1 instead of subpixel experiment with this. the slide feels too fast
			_slopeSlide=true;
			jumpHoldTimer-=.5;//friction against slope. Change .5 to a variable
		}
		//Slide upright slopes ceiling
		if moveDir ==0 && !place_meeting(x+abs(yspd)+1,y+yspd,oWall){
			while place_meeting(x,y+yspd,oWall){x+=1;}; //use 1 instead of subpixel
			_slopeSlide=true;
			jumpHoldTimer-=.5;//friction against slope. Change .5 to a variable
		}
		if !_slopeSlide{
			//Scoot up to the wall precisely
			var _pixelCheck = _subPixel * sign(yspd);
			while !place_meeting(x,y+_pixelCheck,oWall){
				y+=_pixelCheck;
			}
			//bonk code(OPTIONAL)
			//if yspd<0{jumpHoldTimer=0;};
		
			//Set yspd to 0 to collide
			yspd = 0;
		}
	}
	
	//Downwards Y Collision
	if yspd >=0 {
		if place_meeting(x,y+yspd,oWall){
			//Scoot up to the wall precisely
			var _pixelCheck = _subPixel * sign(yspd);
			while !place_meeting(x,y+_pixelCheck,oWall){
				y+=_pixelCheck;
			}
			//Set yspd to 0 to collide
			yspd = 0;
		
		}
		//Set if on ground
		if place_meeting(x,y+1,oWall){
			setOnGround(true);
		} 
	}
	
	//Move
	y+=yspd;

//Sprite Control
	//Walking
	if abs(xspd)>0{sprite_index=walkSpr;};
	//Running
	if abs(xspd)>=moveSpd[1]{sprite_index=runSpr;};
	//Not moving
	if xspd==0{sprite_index=idleSpr;};
	//in the air
	if !onGround{sprite_index=jumpSpr;};
		//set the collision mask
		mask_index=maskSpr;