//Get inputs
getControls();

//sets face
if (face != 0) image_xscale = face;

attackStart=false;

#region Damage Related
if (damageEvent) {
    if(state != "dead")flashAlpha = 1;

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
	

    // Reset damage values
    damage = 0;
    damageType = "none";
    damageEvent = false;
}


//reduce flash
if (flashAlpha>0){
	flashAlpha-=.05;
}

#endregion

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




switch (state) {
	case "free":
		//isAttacking=false;
		//Sprite Control
		//Walking
		if abs(xspd)>0{sprite_index=walkSpr;};
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
		
		
		NPC_MEET = instance_place(x,y,oNPC);
		/*
		if (NPC_MEET && interactKeyPressed && NPC_MEET.text_id != ""){
			create_textbox(NPC_MEET.text_id);
		}
		*/
		
		//interact events can't happen if a textbox exists
		if (!instance_exists(oTextBox)){
				if (NPC_MEET && interactKeyPressed){
				NPC_MEET.interactEvent = true;
			}
		}
		
		player_dodge();
		player_movement_collisions();

	break;
	
	case "attack":
		sprite_index = knifeAttack0Spr;
		//isAttacking=true;
		player_attack_damage(1);
		player_attack_command("attackcombo1",sPlayerKnifeAttack1HB,5);
		player_dodge();
	
		//if animation ends
		if image_index >=image_number-1 {
			state="free";
			instance_destroy(myHitBox);
			};
		
	
		player_x_collision();
		player_y_collision();
	
	break;
	
	case "attackcombo1":
		sprite_index = knifeAttack1Spr;
		//isAttacking=true;
		player_attack_damage(1);
		player_attack_command("attackcombo2",sPlayerKnifeAttack2HB,5)
		player_dodge();
	
		//if animation ends
		if image_index >=image_number-1 {
			state="free";
			instance_destroy(myHitBox);
			};
	
		player_x_collision();
		player_y_collision();
	
	
	
	break;
	
	case "attackcombo2":
		sprite_index=sPlayerKnifeAttack2;
		//isAttacking=true;
		player_attack_damage(2);
		
		//if animation ends
		if image_index >=image_number-1 {
			state="free";
			instance_destroy(myHitBox);
			};
		
		player_x_collision();
		player_y_collision();
		
	break;
	
	case "hurt":
	//isAttacking=false;
	break;
	
	case "crouch_start":
		//isAttacking=false;//set in each state where attack isn't happening
		mask_index=crouchSpr;
		sprite_index=idleCrouchSpr
		if image_index >=image_number-1 {state="crouch";};
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
		if image_index >=image_number-1 {state="free";};
		
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
	case "dead":
		//isAttacking=false;
		sprite_index=deathSpr;
		if (image_index>=image_number-1){image_speed=0;};
		face=0;
	break;
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



/*

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
	if crouching && crouchStart==false{
		sprite_index=idleCrouchSpr
		if image_index >=image_number-1 {crouchStart=true;};
	}
	
	if crouching && crouchStart==true{sprite_index=crouchSpr;};
		//set the collision mask
		mask_index=maskSpr;
		if crouching{mask_index=crouchSpr;};
		if crouching && xspd !=0 {sprite_index=crawlSpr;};
		
	if !crouching {crouchStart=false;};
	
	*/