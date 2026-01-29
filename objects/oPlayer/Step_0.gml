//Get inputs
getControls();

//sets face
if (face != 0) image_xscale = face;

attackStart=false;



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



	//Direction
		moveDir = rightKey - leftKey; //can likely be organizeed outside of states
		//Get my face
		if moveDir!=0{face=moveDir;}; //this too

		//Get xspd
		runType=agileKey;  //can possibly be organized outside of the states
		xspd = moveDir * moveSpd[runType];	

//show_debug_message(state);


if (climbJumpTimer<climbJumpTime){
	climbJumpTimer++;
}

switch (state) {
	case "free":
		//isAttacking=false;
		//Sprite Control
		//Walking
		if abs(xspd)>0{
			sprite_index=walkSpr;
			/*
			var currentFrame = floor(image_index);
			if (currentFrame!=lastFrame){
				if (currentFrame == 0 || currentFrame == 4){
						audio_play_sound(sfx_step,1,false);
						show_debug_message("step");
					}
				lastFrame = currentFrame;
				} */
			} else{
				//lastFrame = -1; // reset so first frame triggers again
			}
			
		var moving = abs(xspd) > 0.1;

		// Detect when movement just started
		if (moving && !wasMoving) {
		    audio_play_sound(sfx_step, 1, false);
		}

		// Normal per-frame step logic
		if (moving) {
		    var currentFrame = floor(image_index);
		    if (currentFrame != lastFrame) {
		        if (currentFrame == 0 || currentFrame == 4) {
		            audio_play_sound(sfx_step, 1, false);
		        }
		        lastFrame = currentFrame;
		    }
		} else {
		    lastFrame = -1;
		}

		// Update for next frame
		wasMoving = moving;
		//Running
		if abs(xspd)>=moveSpd[1]{sprite_index=runSpr;};
		//Not moving
		if xspd==0{sprite_index=idleSpr;};
		//if backstepping
		if (isBackstepping){sprite_index=backStepSpr;};
		//in the air
		if !onGround{sprite_index=jumpSpr;};
		//rolling, can roll in air
		if (isRolling){sprite_index=rollSpr;};

		//Crouching
		//Transition to crouch
		//Manual = onGround / Auto = placemeeting
		if onGround && (downKey || place_meeting(x,y,oWall)) {
			state = "crouch_start";
			image_index=0;
		}

		player_attack_command("attack",sPlayerKnifeAttack0HB,0);
		player_aerial_attack_command("jump_attack",sPlayerJumpAttackHB,0);
		
		
		INTERACT_MEET = collision_circle(x,y,20,oLife,false,true) //instance_place(x,y,oLife);
		/*
		if (NPC_MEET && interactKeyPressed && NPC_MEET.text_id != ""){
			create_textbox(NPC_MEET.text_id);
		}
		*/
		
		//interact events can't happen if a textbox exists
		if (!instance_exists(oTextBox)){
				if (INTERACT_MEET && interactKeyPressed){
				INTERACT_MEET.interactEvent = true;
			}
		}
		
		player_dodge();
		player_movement_collisions();
		
		//Climb code:
		
		if (place_meeting(x,y,oClimb) && !downKey){
			state="climb";
			
			//xspd = 0;
			//yspd = 1*(upKey-downKey);
		
		}
		
		

	break;
	
	case "climb":
		//jumpCount=0; // make sure you always have a jump if you are in climbing mode
		
		setOnGround(true);
		yspd = .7*(downKey-upKey);
		y+=yspd;
		
		sprite_index = sPlayerClimb;
		var _climbspd = .8;
		image_speed= max(_climbspd*downKey,_climbspd*upKey,_climbspd*rightKey,_climbspd*leftKey);
		
		if (!place_meeting(x,y,oClimb)){
			state="free";
			image_speed=1;
		}
		

		#region Modified Jump code
		
			
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
			climbJumpTimer=0;
			//jumpCount=0;
			image_speed=1;
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
		
		#endregion
		
		
		//still need x movement and collisions
		player_x_collision();
		player_x_movement_reduced();
		//player_y_movement();
		player_y_collision();
	
	break;
	
	case "attack":
		sprite_index = knifeAttack0Spr;
		//isAttacking=true;
		player_attack_damage(1);
		player_attack_command("attackcombo1",sPlayerKnifeAttack1HB,3);
		player_dodge();
	
		//if animation ends
		if animation_end() {
			state="free";
			instance_destroy(myHitBox);
			};
		
		
		player_x_collision();
		//player_x_movement_reduced();
		player_y_collision();
	
	break;
	
	case "attackcombo1":
		sprite_index = knifeAttack1Spr;
		//isAttacking=true;
		player_attack_damage(1);
		player_attack_command("attackcombo2",sPlayerKnifeAttack2HB,4)
		player_dodge();
	
		//if animation ends
		if animation_end() {
			state="free";
			instance_destroy(myHitBox);
			};
	
		player_x_collision();
		//player_x_movement_reduced();
		player_y_collision();
	
	
	
	break;
	
	case "attackcombo2":
		sprite_index=sPlayerKnifeAttack2;
		//isAttacking=true;
		player_attack_damage(2);
		
		//if animation ends
		if animation_end() {
			state="free";
			instance_destroy(myHitBox);
			};
		
		player_x_collision();
		player_y_collision();
		
	break;
	case "jump_attack":
		sprite_index=sPlayerJumpAttack;
		//isAttacking=true;
		player_attack_damage(2);
		
		//if animation ends
		if animation_end() {
			state="free";
			instance_destroy(myHitBox);
		};
		
		player_movement_collisions();
	break;
	
	case "hurt":
	//isAttacking=false;
	sprite_index=hurtSpr;
		if animation_end() {
			state="free";
		};
		
	player_x_collision();
	player_y_collision();
	//Below code is a piece of player y movement code, prevents the player from freezing midair on hurt state. Could be an intentional feature though.
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
		
		//Terminal velocity
		if yspd>termVel{yspd=termVel;};
		
		//Move
		if !place_meeting(x,y+yspd,oWall){y+=yspd;};
	
	break;
	
	case "crouch_start":
		//isAttacking=false;//set in each state where attack isn't happening
		mask_index=crouchSpr;
		sprite_index=idleCrouchSpr
		if animation_end() {state="crouch";};
		//Transition out of crouch
		//Manual !downKey / Auto = !onGround
		if (!downKey || !onGround) {
			//check if i CAN uncrouch
			mask_index = idleSpr;
			if !place_meeting(x,y,oWall){
				state = "free";
			} else { //go back to crouching mask index if we can't uncrouch
				mask_index=crouchSpr;
			}
		}
		
				//Transition out of crouch, in the case of losing ground
		if (!onGround) {
			//check if i CAN uncrouch
			mask_index = idleSpr;
			if !place_meeting(x,y,oWall){
				state = "free";
			} else { //go back to crouching mask index if we can't uncrouch
				mask_index=crouchSpr;
			}
		}
		
		//player_x_movement_reduced();
		player_x_collision();
		player_y_collision();
		player_y_movement();
		//if(xspd!=0) {state = "free";};
		
		
		
	break;
	
	case "crouch":
		//isAttacking=false;
		mask_index=crouchSpr;
		sprite_index=crouchSpr;
		//Transition out of crouch
		//Manual !downKey / Auto = !onGround
		if (!downKey && onGround) {
			//check if i CAN uncrouch
			mask_index = idleSpr;
			if !place_meeting(x,y,oWall){
				state = "uncrouch";
				image_index=0;
			} else { //go back to crouching mask index if we can't uncrouch
				mask_index=crouchSpr;
			}
		}
		//Transition out of crouch, in the case of losing ground
		if (!onGround) {
			//check if i CAN uncrouch
			mask_index = idleSpr;
			if !place_meeting(x,y,oWall){
				state = "free";
			} else { //go back to crouching mask index if we can't uncrouch
				mask_index=crouchSpr;
			}
		}
		
		player_movement_collisions();
	
	break;
	
	case "uncrouch" :
		//isAttacking=false;
		mask_index=crouchSpr;
		sprite_index=crouchIdleSpr
		if animation_end() {state="free";};
		
				//Transition out of crouch, in the case of losing ground
		if (!onGround) {
			//check if i CAN uncrouch
			mask_index = idleSpr;
			if !place_meeting(x,y,oWall){
				state = "free";
			} else { //go back to crouching mask index if we can't uncrouch
				mask_index=crouchSpr;
			}
		}
		
		//player_x_movement_reduced();
		player_x_collision();
		player_y_collision();
		player_y_movement();
		if(xspd!=0) {state = "free";};
	
	break;
	
	case "jump_start":
	sprite_index=sPlayerJumpStart;
	player_aerial_attack_command("jump_attack",sPlayerJumpAttackHB,0);
	if (animation_end()||onGround){state="free"};
	
	player_movement_collisions();
	
	if (place_meeting(x,y,oClimb)&&(climbJumpTimer>=climbJumpTime||upKey)&&!downKey){
			state="climb";
			
			//xspd = 0;
			//yspd = 1*(upKey-downKey);
		
		}
	
	break;
	
	case "dead":
		//isAttacking=false;
		sprite_index=deathSpr;
		if (animation_end()){image_speed=0;};
		face=0;
		/*
		if(immortal){
			reviveTimer--;
			if (reviveTimer<=0){
				state = "revive";
				reviveTimer=reviveTime;
				image_speed=1;
			}
		} */
		
		
		player_x_collision();
		player_y_collision();
		
		//Makes sure that when dead, body doesn't freeze midair
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
		
		//Terminal velocity
		if yspd>termVel{yspd=termVel;};
		
		//Move
		if !place_meeting(x,y+yspd,oWall){y+=yspd;};
		
	break;
	
	case "revive":
		sprite_index=reviveSpr;
		if animation_end() {state="free";};
	
	break;
}



if keyboard_check(ord("P")){
	state="dead";
}
	
//Check if I'm crushed
image_blend = c_white;
if place_meeting(x,y,oWall){
	image_blend=c_blue;
}

	
#region Damage Related

if (equippedFlower == noone){
	poiseMax = 0;
	poiseTime = 300;
	poise = 0;
} else {
	poiseMax = equippedFlower.poiseMax;
	poiseTime = equippedFlower.poiseTime;
}

if (poise < poiseMax){
	poiseTimer++;
	if (poiseTimer>=poiseTime){
		poise=poiseMax;
		poiseTimer = 0;
	}
}

if (damageEvent) {
	if(invincibilityBuffer>0){
		invincibilityBuffer--;
	} else {
		if(!invincible){
		    if(state != "dead"){
				flashAlpha = 1;
				poise -= poiseDamage;
				if(poise<=0){
					state="hurt";
				}
			}
		    if (equippedFlower != noone &&(equippedFlower.petals>0 ||equippedFlower.phantom_petals>0)) {
		        // Handle Phantom Damage
		        if (damageType == "phantom" || damageType == "hybrid") {
		            equippedFlower.phantom_petals -= damage;
		            if (equippedFlower.phantom_petals < 0) {
		                equippedFlower.phantom_petals = 0;
		            }
		            show_debug_message("Lost a phantom petal! " + string(equippedFlower.phantom_petals) + " left.");
		        }

		        // Handle Regular Damage
		        if (damageType == "normal" || damageType == "hybrid") {
		            equippedFlower.petals -= damage;
		            if (equippedFlower.petals < 0) {
		                equippedFlower.petals = 0;
		            }
		            show_debug_message("Lost a petal! " + string(equippedFlower.petals) + " left.");
		        }

		        // Check if the entity should die (either petal count reaching 0)
		        if (equippedFlower.petals <= 0 && equippedFlower.phantom_petals <= 0) {
		            show_debug_message("The flower has withered...");
		        }
		    } else {
				if (damage>0){
			        // No flower equipped = instant death
					//you want this? maybe?
			        //if (death_text != "") {create_textbox(death_text);};
			        state = "dead";
			        //ai_state = "dead";
				}
		    }
		}

	    // Reset damage values
	    damage = 0;
	    damageType = "none";
	    damageEvent = false;
		poiseDamage = 0;
		invincibilityBuffer=invincibilityBufferFrames;
	}
}


//reduce flash
if (flashAlpha>0){
	flashAlpha-=.05;
}

if (invincibilityTimer>0){
	invincible=true;
	//show_debug_message("invulnerable")
	invincibilityTimer--;
} else {
	invincible=false;
}


#endregion