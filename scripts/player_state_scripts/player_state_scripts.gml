// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function player_state_scripts(){

}

function player_movement_collisions(){
	player_x_collision()
	player_x_movement()
	player_y_movement()
	player_y_collision()



}



function player_x_collision(){
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
}

function player_x_movement(){
	//Move
		x += xspd;
}

function player_x_movement_reduced(){
	//Move
		x += (.02) * xspd;
}

function player_y_movement(){
	//Gravity
		if coyoteHangTimer>0{
			//count the timer down
			coyoteHangTimer--;  //is it possible we actually get 1 less frame because of where this is?
		}else{
			//Apply gravity to the player
			yspd+=grav;
			//We're no longer on the ground
			setOnGround(false); //need to get surgical with how we replace this
		}
		
	// Jumping
		
	//Rest/Prepare Jump Variables
		 if onGround{
			 jumpCount=0;
			 jumpHoldTimer=0;
			 coyoteJumpTimer=coyoteJumpFrames;
		 }else{
			//if player is in the air make sure they can't do an extra jump
			coyoteJumpTimer--;
			if jumpCount==0&&coyoteJumpTimer<=0{jumpCount=1;};
		 }
		 
	//Prepare to Jump, check if on a platform first
		var _floorIsSolid=false;
		if instance_exists(myFloorPlat)
		&&(myFloorPlat.object_index=oWall||object_is_ancestor(myFloorPlat.object_index,oWall)){
			_floorIsSolid=true;
		}
	
	
		if jumpKeyBuffered && jumpCount<jumpMax && (!downKey||_floorIsSolid){
			state="jump_start";//this might need revision
			image_index=0;
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
		
	//Jump based on the timer/holding the button
		if jumpHoldTimer > 0 {

			//Constantly set the yspd to be jumping speed
			//yspd = jspd[clamp(jumpCount-1, 0, 2)];
			yspd = jspd[jumpCount-1];
			//Count down the timer
			jumpHoldTimer--;
		}
		//Cut off the jump by releasing the jump button

		if !jumpKey{
			jumpHoldTimer=0;
		}
		
		//Terminal velocity
		if yspd>termVel{yspd=termVel;};
		
		//Move
		if !place_meeting(x,y+yspd,oWall){y+=yspd;};
}

//consider breaking Y movement into jumping and gravity

function player_y_collision(){
	
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
	
}

function player_damage_buffer(){}// this will basically be like a poise stat

//consider if you want a roll to be able to be cancelled into an attack
function player_attack_command(_nextState,_attackType,_comboFrame){
	//_nextState is the string that corresponds to the state
	//_attackType is the sprite that corresponds to the attack hitbox
	//_comboFrame refers to the minimum frame you can start the attack from. If you can start the attack anytime, this value is 0.
	
	if (attackKeyPressed && onGround && image_index>=_comboFrame){
		isRolling = false;
		isBackstepping = false;
		//prevents rolling or backstepping to complete after attack is done
		state = _nextState;
		image_index=0;
		myHitBox = instance_create_depth(x,y,depth,oPlayerHitBox,{
			sprite_index : _attackType,
			creatorID : id
			//image_xscale : image_xscale,//*face//for whatever reason, this causes a visual bug if you keep the player hit box visible, but this allows it to work as intended.
			})
		ds_list_clear(hitByAttack);
		attackStart=true;
		};

}

function player_aerial_attack_command(_nextState,_attackType,_comboFrame){
	//_nextState is the string that corresponds to the state
	//_attackType is the sprite that corresponds to the attack hitbox
	//_comboFrame refers to the minimum frame you can start the attack from. If you can start the attack anytime, this value is 0.
	
	if (attackKeyPressed && !onGround && image_index>=_comboFrame){
		isRolling = false;
		isBackstepping = false;
		//prevents rolling or backstepping to complete after attack is done
		state = _nextState;
		image_index=0;
		myHitBox = instance_create_depth(x,y,depth,oPlayerHitBox,{
			sprite_index : _attackType,
			creatorID : id
			//image_xscale : image_xscale,//*face//for whatever reason, this causes a visual bug if you keep the player hit box visible, but this allows it to work as intended.
			})
		ds_list_clear(hitByAttack);
		attackStart=true;
		};

}

function player_attack_damage(_damage=1, _damageType="normal",_poiseDamage=10){ //damage should just be 1 or 2
	with (myHitBox) {
		var hitByAttackNow = ds_list_create();
		var hits = instance_place_list(x,y,oLife,hitByAttackNow,false);
		if (hits > 0){
			for (var i=0;i<hits;i++){
				//if this instance has not yet been hit by this attack
				var hitID = hitByAttackNow[| i];
				if (ds_list_find_index(other.hitByAttack,hitID)==-1 && hitID != other.id){ //conditions prevent the player from being hit by self
					ds_list_add(other.hitByAttack,hitID);
					with (hitID) {
						//whatever is gonna happen to the enemy
						//write a damage event
						damage+=_damage;
						damageType=_damageType;
						damageEvent=true;
						poiseDamage=_poiseDamage;
					}
				}
		
			}
	
		}
		ds_list_destroy(hitByAttackNow);
	}
}

function player_dodge(){
		
		///////////////////////////////
		// Check for agileKey tap
		if (agileKeyPressed) {
			if(state != "free") state="free";
		    agileTapTimer = agileTapBuffer;
			
		}

		// Decrement timer if it's active
		if (agileTapTimer > 0) {
		    agileTapTimer--;
		    // Check if key is released before timer ends (trigger backstep)
		    if (!agileKey) { // if there is a directional input the player should roll instead
		        
				// Check for roll input
		        if (leftKey || rightKey) {
		            isRolling = true;
		            isBackstepping = false;
					rollTimer = rollTime;
					invincibilityTimer=invincibilityTime+rollTime;
		            //invulnerable = true;
				} else {
					isBackstepping = true;
			        agileTapTimer = 0;
					backstepTimer = backstepTime; //timer start
					invincibilityTimer=invincibilityTime+backstepTime;
			        //invulnerable = true; // Optional
					//show_debug_message("backstep released")
				}
		    }
		}

		// Handle backstep movement
		if (isBackstepping) { // This could technically be a new state, but I think it works for free state
		    backstepTimer--;
			//show_debug_message("backstep?")
		    // Move in the opposite direction of facing
		    xspd = face * (1-backstepSpeed);
    
		    // End backstep
		    if (backstepTimer <= 0) {
		        isBackstepping = false;
		        //invulnerable = false; // Optional: End invulnerability
		    }
		}
		
		// Handle roll movement
		if (isRolling) {
		    rollTimer--;
    
		    // Move in the direction pressed
		    /*
			if (rightKey) {
		        x += rollSpeed;
		        facingRight = true;
		    }
		    else if (leftKey) {
		        x -= rollSpeed;
		        facingRight = false;
		    } */
			
			xspd = face * rollSpeed;
    
		    // End roll
		    if (rollTimer <= 0) {
		        isRolling = false;
		        //invulnerable = false; // Optional: End invulnerability
		    }
		}
		
		
		//////////////////////////////

}