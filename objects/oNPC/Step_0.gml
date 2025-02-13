getControlsNPC();


//sets face
if (face != 0) image_xscale = face;

#region damage related
if (HP <= 0 && !invincible){
	if (oTextBox){
		with (oTextBox) { //this could be risky. ANY textbox will be destroyed on NPC death. Be sure to make it so it either doesn't matter, or prevent it from happening if it would
			instance_destroy();
		}
	}
	if (death_text != ""){create_textbox(death_text); }//death dialogue. Later you may have to send this data to an external game object that keeps a list of deaths to prioritize death dialogue in the case of multiple simultaneous deaths. Or implement timer. Or both.
	instance_destroy();//ANY destroy event must also destroy objects created by this object(unless there are no dependencies)
}



//Flash
if (damageEvent){
	flashAlpha = 1;
}
//reduce flash
if (flashAlpha>0){
	flashAlpha-=.05;
}

//Damage event code should be reset every frame. //this could later be augmented with a buffer/timer
damageEvent = false;
#endregion

#region interaction code
//originally in create event, but needs to be in step event. Gets amount of dialogues
textMax = array_length(text_id); // Get the maximum text entries
cycleMax = array_length(cycle_id); //same as above but for cycle mode

//If player pressed interact button
if (interactEvent){
	
	if (text_id[0] != ""){
		if (!cycleMode){
			myTextbox = create_textbox(text_id[text_index]);
			myTextbox.creatorID = object_index;
	

		} else {
			myTextbox = create_textbox(cycle_id[cycle_index]);
			myTextbox.creatorID = object_index;
		}
	}
	interactEvent = false;
	
} 

if (myTextbox){
	if (distance_to_object(oPlayer)>talkRange){

		with(myTextbox){
			instance_destroy();
		}
	}
	

}

if (nextFlag){
	if(!cycleMode){
		if (text_index<textMax-1){
			text_index++;
		}
	} else {
		if (!cycleType){ //If cycling is ordered
			cycle_index++;
			if (cycle_index>=cycleMax){
				cycle_index = 0;
			}
			//show_message(cycleMode);
		} else { //if cycling is random
			cycle_index = irandom(cycleMax-1);
			if (cycleMax-1 !=0){
				while (cycle_index = lastCycle){ //Makes sure you don't repeat the last dialogue
					cycle_index = irandom(cycleMax-1);
				}
			}
			
			lastCycle = cycle_index;
			//There is one caveat. If the cycle and non cycle dialogues are the same, it could repeat a dialogue on the first time. Not worth it to me to figure out how to deal with it.
		}
	}
	

	
	nextFlag = false;
}

#endregion

//Get out of solid moveplats that have positioned themselvesinto the NPC in the begin step
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
		moveDir = rightAction - leftAction; //can likely be organizeed outside of states
		//Get my face
		if moveDir!=0{face=moveDir;}; //this too

		//Get xspd
		runType=runAction;  //can possibly be organized outside of the states
		xspd = moveDir * moveSpd[runType];	

//xspd = moveDir * moveSpd[0];


//quick set up for idle movement. For test purposes



	//Get my face
		if moveDir!=0{face=moveDir;};
		
		

var groundAhead = (place_meeting(x+xspd+(ledgeBuffer*moveDir),y+1,oWall) || place_meeting(x+xspd+(ledgeBuffer*moveDir),y+1,oSemiSolidWall))

if (!groundAhead && onGround ){
	xspd = 0;
}  //this will need to be updated to work in tandem with returning to home, and jumping when safe





// Get relation to player (individual preference OR faction-based)
if (instance_exists(oPlayer)){ // probably unnecessary, implemented for testing
	var relation_to_player = GetNPCRelation(oPlayer.id);
}
//State Machine
#region statemachine
/*
switch (state) {
	case "docile":
	
		if (instance_exists(oPlayer)){ // probably can get rid of this, for testing
			//If this NPC doesn't like the player and is close to them, aggro
			 if (relation_to_player == relation.enemy && point_distance(x, y, oPlayer.x, oPlayer.y) < 150) {
	            state = "aggressive"; // Attack enemies
				moveDir = 0;
	        } 
		}
	
		if (!dirSet){
			if (prevDir!=0){ // this behavior basically makes it so that when the NPC is idly moving, it will stop after each movement and not keep running around.
				moveDir = 0;
				dirSet = true;
				
			} else {
				while (moveDir = prevDir){
					moveDir = choose(-1,0,1);
					dirSet = true;
				}
			} 
			prevDir = moveDir;
		} else {
			moveTimer--;
			if (moveTimer <= 0){
				moveTimer=irandom(moveTime);
				dirSet=false;
				}
		} 
		if (stationary){ // you need to clean this up and refine this
			moveTimer--;
			moveDir = 0;
			if (moveTimer<=0){
				face = choose(-1,1);
				moveTimer=irandom(moveTime);
			}
		}
	
	break;
	
	case "aggressive":
		image_blend = c_red;
	break;

}

*/
#endregion
switch (state) {
	case "free":
		NPC_collisions_movement()
		//Sprite Control
		//Walking
		if abs(xspd)>0{sprite_index=walkSpr;};
		//Running
		if abs(xspd)>=moveSpd[1]{sprite_index=runSpr;};
		//Not moving
		if xspd==0{sprite_index=idleSpr;};
		//in the air
		if !onGround{sprite_index=jumpSpr;};

		NPC_attack_command("attack",attack0SprHB,0);
	
		/*
		//Crouching
		//Transition to crouch
		//Manual = onGround / Auto = placemeeting
		if onGround && (downKey || place_meeting(x,y,oWall)) {
			state = "crouch_start";
			image_index=0;
		}

		*/
		

	break;
	
	case "attack":
		sprite_index = attack0Spr;
		NPC_attack_damage(2);
		
		//if animation ends
		if image_index >=image_number-1 {
			state="free";
			instance_destroy(myHitBox);
			};
		/*sprite_index = knifeAttack0Spr;
	
		player_attack_damage(2);
		player_attack_command("attackcombo1",sPlayerKnifeAttack1HB,5);
	
	
		//if animation ends
		if image_index >=image_number-1 {
			state="free";
			instance_destroy(myHitBox);
			};
		
	
		player_x_collision();
		player_y_collision();
		*/
		NPC_x_collision();
		NPC_y_collision();
	
	break;
	
	case "attackcombo1":
		/*sprite_index = knifeAttack1Spr;
		player_attack_damage(2);
		player_attack_command("attackcombo2",sPlayerKnifeAttack2HB,5)
	
		//if animation ends
		if image_index >=image_number-1 {
			state="free";
			instance_destroy(myHitBox);
			};
		*/
		NPC_collisions_movement();
	
	
	
	break;
	
	case "attackcombo2":
		/*sprite_index=sPlayerKnifeAttack2;
		player_attack_damage(4);
		
		//if animation ends
		if image_index >=image_number-1 {
			state="free";
			instance_destroy(myHitBox);
			}; */
		
		NPC_collisions_movement();
		
	break;
	
	case "hurt":
	break;
	
	
}



/*
//primitive jumping method
if (jumpActionStart) {
	jumpActionStart=false;
	jumpAction = true;
	jumpTimer = jumpTime;
} // act like a keyboard check pressed

if (jumpTimer>0){
	jumpTimer--;
} else {
	if (jumpAction){
		jumpAction=false;
	}
}

randomJumpTimer++;
if (randomJumpTimer >= randomJumpTime){
	randomJumpTimer=0;
	jumpActionStart = choose(0,1)
}
*/


	/*
//for debug sake
jumpAction = keyboard_check(vk_space);
jumpActionStart = keyboard_check_pressed(vk_space);
*/

/*

if (xspd = 0) {
		sprite_index=idleSpr
	} else {
		sprite_index=walkSpr
	}
	*/