//Get inputs
getControls();


//Get out of solid moveplats that have positioned themselvesinto the player in the begin step
#region moving wall collisions
	var _rightWall=noone;
	var _leftWall=noone;
	var _bottomWall=noone;
	var _topWall=noone;
	var _list = ds_list_create();
	var _listSize = instance_place_list(x,y,oMovePlat,_list,false);
	
	//loop through all the colliding  move plats
	for(var i=0;i<_listSize;i++){
		var _listInst = _list[| i];
		
		//Find closest walls in each direction
			//Right Walls
			if _listInst.bbox_left - _listInst.xspd >= bbox_right-1{
				if !instance_exists(_rightWall) || _listInst.bbox_left < _rightWall.bbox_left {
					_rightWall = _listInst;
				}
			}
			//Left Walls
			if _listInst.bbox_right - _listInst.xspd <= bbox_left+1{
				if !instance_exists(_leftWall) || _listInst.bbox_right > _leftWall.bbox_right {
					_leftWall = _listInst;
				}
			}
			//Bottom Wall
			if _listInst.bbox_top - _listInst.yspd >= bbox_bottom-1{
				if !instance_exists(_bottomWall) || _listInst.bbox_top < _bottomWall.bbox_top {
					_bottomWall = _listInst;
				}
			}
			//Top Wall
			if _listInst.bbox_bottom - _listInst.yspd <= bbox_top+1{
				if !instance_exists(_topWall) || _listInst.bbox_bottom > _topWall.bbox_bottom {
					_topWall = _listInst;
				}
			}
	}
	
	//destroy the ds lsit to free memory
	ds_list_destroy(_list);
	
	//Get out of the walls
		//Right wall
		if instance_exists(_rightWall){
			var _rightDist = bbox_right - x;
			x = _rightWall.bbox_left - _rightDist;
		}
		//Left Wall
		if instance_exists(_leftWall){
			var _leftDist = x - bbox_left;
			x = _leftWall.bbox_right + _leftDist;
		}
		//Bottom Wall
		if instance_exists(_bottomWall){
			var _bottomDist = bbox_bottom - y;
			y = _bottomWall.bbox_top - _bottomDist;
		}
		//Top Wall
		if instance_exists(_topWall){
			var _topDist = y - bbox_top;
			var _targetY = _topWall.bbox_bottom + _topDist;
			//Check if there isn't a wall in the way
			if !place_meeting(x,_targetY,oWall){
				y = _targetY;
			}
		}
#endregion

//Don't get left behind by my moveplat !
earlyMoveplatXspd=false;
if instance_exists(myFloorPlat) && myFloorPlat.xspd != 0 && !place_meeting(x,y+moveplatMaxYspd+1, myFloorPlat){
	
	var _xCheck = myFloorPlat.xspd;
	//Go ahead and move ourselves back onto the platform if there is no wall in the way
	if !place_meeting(x+_xCheck,y,oWall){
		x+= _xCheck;
		earlyMoveplatXspd=true;
	}
}

//Crouching
	//Transition to crouch
		//Manual = onGround / Auto = placemeeting
		if onGround && (downKey || place_meeting(x,y,oWall)) {
			crouching=true;
		}
		/*//Forced / Automatic
		if onGround && place_meeting(x,y,oWall){
			crouching=true;
		} //*/
		//Change collision mask
		if crouching {mask_index=crouchSpr;};
		
	//Transition out of crouch
		//Manual !downKey / Auto = !onGround
		if crouching && (!downKey || !onGround) {
			//check if i CAN uncrouch
			mask_index = idleSpr;
			if !place_meeting(x,y,oWall){
				crouching=false;
			} else { //go back to crouching mask index if we can't uncrouch
				mask_index=crouchSpr;
			}
		}
	


//X Movement
	//Direction
	moveDir = rightKey - leftKey;
	//Get my face
	if moveDir!=0{face=moveDir;};

	//Get xspd
	runType=runKey;
	xspd = moveDir * moveSpd[runType];
	
	/*//Stop xspd if crouching
	if crouching {xspd=0;}; // You may set a crouch speed
	//*/

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
	
	//Go Down Slopes
	downSlopeSemiSolid=noone;
	if yspd>=0 && !place_meeting(x+xspd,y+1,oWall) && place_meeting(x+xspd,y+abs(xspd)+1,oWall){
		//Check for a semisolid in the wway
		downSlopeSemiSolid=checkForSemisolidPlaform(x+xspd,y+abs(xspd)+1);
		//Precisely move down the slope if there isn't a semisolid in the way
		if !instance_exists(downSlopeSemiSolid){
			while !place_meeting(x+xspd,y+_subPixel,oWall){y+=_subPixel;};
		}
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
	var _floorIsSolid=false;
	if instance_exists(myFloorPlat)
	&&(myFloorPlat.object_index=oWall||object_is_ancestor(myFloorPlat.object_index,oWall)){
		_floorIsSolid=true;
	}
	
	
	
	if jumpKeyBuffered && jumpCount<jumpMax && (!downKey||_floorIsSolid){
		
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
	
	#region //option A jump cut off
	/*
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
	} //*/
	#endregion
	//Jump based on the timer/holding the button
	if jumpHoldTimer > 0 {

		//Constantly set the yspd to be jumping speed
		yspd = jspd[clamp(jumpCount-1, 0, 2)];
		//Count down the timer
		jumpHoldTimer--;
	}
	//Cut off the jump by releasing the jump button

	if !jumpKey{
		jumpHoldTimer=0;
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
	
	//Floor Y Collision

	//Check for solid and semisolid platforms under me
	var _clampYspd = max(0,yspd);
	var _list = ds_list_create(); // create a DS list to store all the objects we run into
	var _array = array_create(0);
	array_push(_array,oWall,oSemiSolidWall);
	
	//Do the actual check and add objects to list
	var _listSize = instance_place_list(x,y+1+_clampYspd+moveplatMaxYspd,_array,_list,false);
	
		/////(FIX FOR HIGH RES/HIGH SPEED PROJECTS - same principal as how it's fixed for downward slops
		var _yCheck = y+1 + _clampYspd;
		if instance_exists(myFloorPlat){_yCheck+=max(0,myFloorPlat.yspd);};
		var _semiSolid = checkForSemisolidPlaform(x,_yCheck);
	
	//Loop through the colliding instances and only return one if it's top is below the player
	for(var i=0;i<_listSize;i++){
		//get an instance of oWall of oSemiSolidWall from the list
		var _listInst = _list[| i]; //Same as: = ds_list_find_value(_list,i);
		
		//avoid Magnestism
		if (_listInst != forgetSemiSolid
		&& (_listInst.yspd<=yspd||instance_exists(myFloorPlat))
		&& (_listInst.yspd>0||place_meeting(x,y+1+_clampYspd,_listInst)))
		||(_listInst==_semiSolid){ /////(HIGH SPEED FIX)
			//Return a solid wall or any semisolid walls that are below the player
			if _listInst.object_index==oWall
			|| object_is_ancestor(_listInst.object_index,oWall)
			|| floor(bbox_bottom) <= ceil(_listInst.bbox_top-_listInst.yspd){
				//Return the "highest" wall object
				if !instance_exists(myFloorPlat)
				|| _listInst.bbox_top+_listInst.yspd <= myFloorPlat.bbox_top+myFloorPlat.yspd
				|| _listInst.bbox_top+_listInst.yspd <= bbox_bottom {
					myFloorPlat=_listInst;
				}
		
			}
		}
		
	}
	//Destroy the DS list to avoid a memory leak
	if instance_exists(myFloorPlat) && !place_meeting(x,y+moveplatMaxYspd,myFloorPlat){
		myFloorPlat=noone;
	}
	
	//Downslope semisolid for making sure we don't miss semisolid's while going down slopes
	if instance_exists(downSlopeSemiSolid){myFloorPlat=downSlopeSemiSolid;};
	
	//One Last check to make sure the floor platform is actually below us
	if instance_exists(myFloorPlat) && !place_meeting(x,y+moveplatMaxYspd,myFloorPlat){
		myFloorPlat=noone;
	}
	
	//Land on the ground platform if there is one
	if instance_exists(myFloorPlat){
		//Scoot up to our wall precisely
		var _subPixel = .5;
		while !place_meeting(x,y+_subPixel,myFloorPlat) && !place_meeting(x,y,oWall){y+=_subPixel;};
		//Make sure we don't end up below thetop of a semisolid
		if myFloorPlat.object_index==oSemiSolidWall||object_is_ancestor(myFloorPlat.object_index,oSemiSolidWall){
			while place_meeting(x,y,myFloorPlat){y-=_subPixel};
		}
		//Floor the y variable
		y=floor(y);
		
		//Collide with the ground
		yspd=0;
		setOnGround(true);
	}
	
	//Manually fall through a semisolid platform
	if downKey && jumpKeyPressed{
		//Make sure we have a floor platform thats a semisolid
		if instance_exists(myFloorPlat)
		&&(myFloorPlat.object_index==oSemiSolidWall || object_is_ancestor(myFloorPlat.object_index,oSemiSolidWall)){
			//Check if we can go below the semisolid
			var _yCheck = max(1,myFloorPlat.yspd+1)
			if !place_meeting(x,y+_yCheck,oWall){
				//Move below the platform
				y+=1;
				
				//inherit any downward speed from my floor platform so it doesn't catch me
				yspd = _yCheck-1;
				
				//forget this platform for a broef time so we don't get caught again
				forgetSemiSolid = myFloorPlat;
				
				//reset jump buffer ******
				jumpKeyBuffered=false;
				
				//no more floor platform
				setOnGround(false);
			}
		}
	}
 
	//Move
	if !place_meeting(x,y+yspd,oWall){y+=yspd;};
	
	//rest forgetSemiSolid variable
	if instance_exists(forgetSemiSolid) && !place_meeting(x,y,forgetSemiSolid){
		forgetSemiSolid=noone;
	}
	
//Final moving platform collisions and 
	//X - moveplatXspd and collision
	//Get movePLatXspd
	moveplatXspd=0;
	if instance_exists(myFloorPlat){moveplatXspd=myFloorPlat.xspd;};
	
	//Move with moveplatXspd
	if !earlyMoveplatXspd{
		if place_meeting(x+moveplatXspd,y,oWall){
			//Scoot up to the wall precisely
			var _subPixel=.5
			var _pixelCheck=_subPixel*sign(moveplatXspd);
			while !place_meeting(x+_pixelCheck,y,oWall){
				x+=_pixelCheck;
			}
			//Set moveplatXspd to 0 to finish collision
			moveplatXspd=0;
		}
		//Move
		x+=moveplatXspd;
	}

	//Y - SNap myself to myFlooPlat
	if instance_exists(myFloorPlat) 
	&& (myFloorPlat.yspd != 0
	|| myFloorPlat.object_index==oMovePlat
	|| object_is_ancestor(myFloorPlat.object_index,oMovePlat)
	|| myFloorPlat.object_index==oSemiSolidMovePlat
	|| object_is_ancestor(myFloorPlat.object_index,oSemiSolidMovePlat)){
		//Snap to the top of the floor platform //Unfloor our y platform so it's not choppy
		if !place_meeting(x,myFloorPlat.bbox_top,oWall)
		&& myFloorPlat.bbox_top >= bbox_bottom-moveplatMaxYspd{
			y=myFloorPlat.bbox_top;
		}
		
		#region old redunadant code
		/*/Going up into a solid wall while on a semisolid platform
		if myFloorPlat.yspd < 0 && place_meeting(x,y+myFloorPlat.yspd,oWall){
			//Get Pushed down through the semisolid floor platform
			if myFloorPlat.object_index==oSemiSolidWall || object_is_ancestor(myFloorPlat.object_index,oSemiSolidWall){
				//Get pushed down
				var _subPixel=.25;
				while place_meeting(x,y+myFloorPlat.yspd,oWall){y+=_subPixel;};
				//IF we got pushed into a solid wall while going downwards, ppush ourselves back out
				while place_meeting(x,y,oWall){y-=_subPixel;};
				y=round(y);
			}
			
			//Cancel Semi Solid Platform
			setOnGround(false);
		} */ //tis now redundant
		#endregion
	}

	//Get pushed down through a semisolid by a moving platform
	if instance_exists(myFloorPlat)
	&& (myFloorPlat.object_index == oSemiSolidWall || object_is_ancestor(myFloorPlat.object_index,oSemiSolidWall))
	&& place_meeting(x,y,oWall){
		//if i'm already stuck in a wall at this poin, try and move me down to get below a semisolid
		//if I'm stillstuck afterwards, that just means I've been properly "crushed"
		
		//Also, don't check too far, we don't want to warp below walls
		var _maxPushDist = 10; // the fastest a moveplat should be able to move downwards
		var _pushedDist = 0;
		var _startY = y;
		while place_meeting(x,y,oWall) && _pushedDist <= _maxPushDist {
			y++;
			_pushedDist++;
		}
		//forget my floorplat
		myFloorPlat=noone; //or set on ground false, or noone?
		
		//if i'm still in a wall at this point, I've been crushed regardless, take me back to my start y to avoid the funk
		if _pushedDist > _maxPushDist {y=_startY;};
		
		//Reset jump buffer *****
		jumpKeyBuffered=false;
			
	}
	
	
//Check if I'm crushed
image_blend = c_white;
if place_meeting(x,y,oWall){
	image_blend=c_blue;
}

/*
//Crushed death or damage code
if place_meeting(x,y,oWall){
	crushTimer++;
	if crushTimer>crushDeathTime{
		instance_destroy();
	}
} else {
	crushTimer=0;
} //*/





//Sprite Control
	//Walking
	if abs(xspd)>0{sprite_index=walkSpr;};
	//Running
	if abs(xspd)>=moveSpd[1]{sprite_index=runSpr;};
	//Not moving
	if xspd==0{sprite_index=idleSpr;};
	//in the air
	if !onGround{sprite_index=jumpSpr;};
	//Crouching
	if crouching{sprite_index=crouchSpr;};
		//set the collision mask
		mask_index=maskSpr;
		if crouching{mask_index=crouchSpr;};