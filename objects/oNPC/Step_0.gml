//getControlsNPC();


//sets face
if (face != 0) image_xscale = face;

#region damage related
//retired
/*
if (HP <= 0 && !invincible){
	if (oTextBox){
		with (oTextBox) { //this could be risky. ANY textbox will be destroyed on NPC death. Be sure to make it so it either doesn't matter, or prevent it from happening if it would
			instance_destroy();
		}
	}
	if (death_text != ""){create_textbox(death_text); }//death dialogue. Later you may have to send this data to an external game object that keeps a list of deaths to prioritize death dialogue in the case of multiple simultaneous deaths. Or implement timer. Or both.
	instance_destroy();//ANY destroy event must also destroy objects created by this object(unless there are no dependencies)
}

*/

//Flash
/*
if (damageEvent){
	flashAlpha = 1;
	
	if (equippedFlower != noone && equippedFlower.petals > 0) {
        equippedFlower.petals -= damage; // Lose a petal
        if (equippedFlower.petals == 0) {
            show_debug_message("The flower has withered...");
        } else {
            show_debug_message("Lost a petal! " + string(equippedFlower.petals) + " left.");
        }
    } else {
        //Die(); // No petals left, normal death
		if (death_text != ""){create_textbox(death_text); }//death dialogue. Later you may have to send this data to an external game object that keeps a list of deaths to prioritize death dialogue in the case of multiple simultaneous deaths. Or implement timer. Or both.
		//instance_destroy();
		state="dead";
		ai_state="dead";
    }
	
	damage=0;
	damageType="none"
	//Damage event code should be reset every frame. //this could later be augmented with a buffer/timer
	damageEvent = false;
} 
*/

if (damageEvent) {
    flashAlpha = 1;

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
	        if (death_text != "") {
	            create_textbox(death_text);
	        }
	        state = "dead";
	        ai_state = "dead";
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

#region interaction code
//originally in create event, but needs to be in step event. Gets amount of dialogues
textMax = array_length(text_id); // Get the maximum text entries
cycleMax = array_length(cycle_id); //same as above but for cycle mode

//If player pressed interact button
if (interactEvent){
	
	if (text_id[0] != ""){
		if (!cycleMode){
			myTextbox = create_textbox(text_id[text_index]);
			myTextbox.creatorID = id;
	

		} else {
			myTextbox = create_textbox(cycle_id[cycle_index]);
			myTextbox.creatorID = id;
		}
	}
	interactEvent = false;
	
} 

if (myTextbox){
	if (distance_to_object(oPlayer)>talkRange){

		with(myTextbox){
			if (creatorID == other.id){
				instance_destroy();
			}
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
		runType=agileAction;  //can possibly be organized outside of the states
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



//Action handling
/*
// Reset single-frame actions --- consolidate this into a function
jumpActionStart = false;
attackActionStart = false;
rightAction=false;
leftAction=false;
idleAction = false;
*/

#region old 
/*
// Get all active actions
var keys = variable_struct_get_names(action_queue);
for (var i = 0; i < array_length(keys); i++) {
    var key = keys[i];

 if (action_queue[$ key].duration > 0) {
        switch (key) {
            case "jump":
                jumpAction = true;
                if (action_queue[$ key].duration == 1) jumpActionStart = true;
                break;

            case "attack":
                attackAction = true;
                if (action_queue[$ key].duration == 1) attackActionStart = true;
                break;

            case "move_left":
                leftAction = true;
                break;

            case "move_right":
                rightAction = true;
                break;

        }
        // Decrease timer
        action_queue[$ key].duration--;

        // Remove action when it expires
        if (action_queue[$ key].duration <= 0) {
            struct_remove(action_queue, key);
			break;
        }
		
		  // If this action is sequential, stop processing further actions
       if (action_queue[$ key].sequential) {
            //sequential_mode = true;
            break;
        }
    }
}
*/
#endregion
#region old
/*
// Get all active actions
var keys = variable_struct_get_names(action_queue);
var sequential_mode = false; // Track if we should execute sequentially this frame

for (var i = 0; i < array_length(keys); i++) {
    var key = keys[i];
    var action = action_queue[$ key];

    if (action.duration > 0) {
        switch (key) {
            case "jump":
                jumpAction = true;
                if (action.duration == 1) jumpActionStart = true;
                break;

            case "attack":
                attackAction = true;
                if (action.duration == 1) attackActionStart = true;
                break;

            case "move_left":
                leftAction = true;
                break;

            case "move_right":
                rightAction = true;
                break;
				
			case "idle": // New "do nothing" action
                idleAction = true;
                break;

        }

        // Decrease timer
        action_queue[$ key].duration--;

        // Remove action when it expires
        if (action_queue[$ key].duration <= 0) {
            struct_remove(action_queue, key);
        }

        // If this action is sequential, stop processing further actions
        if (action.sequential) {
            sequential_mode = true;
            break;
        }
    }
} */

#endregion
#region old
/*
if (array_length(action_queue) > 0) {
    var action = action_queue[0]; // Get the first action in the queue

    switch (action._name) {
        case "jump":
            jumpAction = true;
            if (action.duration == 1) jumpActionStart = true;
            break;

        case "attack":
            attackAction = true;
            if (action.duration == 1) attackActionStart = true;
            break;

        case "left":
            leftAction = true;
            break;

        case "right":
            rightAction = true;
            break;

        case "idle": 
            idleAction = true;
            break;
    }

    // Reduce duration
    action.duration--;

    // If action is finished, remove it from the queue
    if (action.duration <= 0) {
        array_delete(action_queue, 0, 1); // Remove the first action
    }

}
*/

/*
if (array_length(action_queue) > 0) {
    var action = action_queue[0]; // Get the first action in the queue

    // Reset all input variables
    leftAction = false;
    rightAction = false;
    jumpAction = false;
    jumpActionStart = false;
    attackAction = false;
    attackActionStart = false;
    idleAction = false;

    // Execute action based on its type
    switch (action._name) {
        case "jump":
            jumpAction = true;
            if (action.duration == 1) jumpActionStart = true;
            break;

        case "attack":
            attackAction = true;
            if (action.duration == 1) attackActionStart = true;
            break;

        case "left":
            leftAction = true;
            break;

        case "right":
            rightAction = true;
            break;

        case "idle":
            idleAction = true;
            break;
    }

    // Reduce duration
    action_queue[0].duration--;

    // If action is finished, remove it from the queue
    if (action_queue[0].duration <= 0) {
        array_delete(action_queue, 0, 1); // Remove completed action
    }
}

*/
#endregion
		//this is the action handler
if (array_length(action_queue) > 0) {
	var current_actions = action_queue[0];// get the first entry
	
	// Reset all input variables
    leftAction = false;
    rightAction = false;
    jumpAction = false;
    jumpActionStart = false;
    attackAction = false;
    attackActionStart = false;
    idleAction = false;
	agileAction = false;
	agileActionStart = false;
	
	//Process each action present in the struct
	var keys = variable_struct_get_names(current_actions); //stores all the keys of current struct into an array as strings
	for (var i=0;i<array_length(keys);i++){
		var action = keys[i]; //store key of current struct
		
		switch (action) {
			case "jump":
				jumpAction = true;
				if (current_actions[$ action].duration == 1) jumpActionStart=true;
				break;
				
			case "attack":
                attackAction = true;
                if (current_actions[$ action].duration == 1) attackActionStart=true;
                break;
				
			case "agile":
                agileAction = true;
                if (current_actions[$ action].duration == 1) agileActionStart=true;
                break;

            case "left":
                leftAction = true;
                break;

            case "right":
                rightAction = true;
                break;

            case "idle":
                idleAction = true;
                break;
		
		}
		
		//Reduce duration
		current_actions[$ action].duration--;
		
		//remove finished actions
		if (current_actions[$ action].duration <= 0){
			struct_remove(current_actions, action);
		}
	}
	
	// If all the actions in the current step are done, move to the next one
	if (array_length(variable_struct_get_names(current_actions)) == 0){ //if the struct at the current index is now empty
		array_delete(action_queue,0,1); //delete first entry of the array
		action_count = max(0,action_count-1); // prevent negative index
	}

}



//show_debug_message(string(action_queue));

if keyboard_check_pressed(ord("B")){
	//QueueAction("jump",1);
			//QueueAction("right",30)
			//QueueAction("idle",50)
			//QueueAction("left",20)
			//QueueAction("idle",60)
			//QueueAction("jump",1,false)
			//("right",40)
			//QueueAction("idle",60)
			QueueAction("right",20,false);
			QueueAction("agile",1);
			

}

//the way jumping works, you need to keep this underneath the action handler
//Jump Buffering
	if jumpActionStart{
		jumpBufferTimer =jumpBufferTime;
	}
	if jumpBufferTimer>0{
		jumpBuffered=true;
		jumpBufferTimer--;
	}else{
		jumpBuffered=false;
	}
	



//State Machine for behavior

#region statemachine

//Determine target if potential target exists


var target_list = ds_list_create();
collision_circle_list(x,y,aggro_range,oLife,false,true,target_list,true);
var nearest_dist = aggro_range;

	
//Loop through potential targets
for (var i=0; i<ds_list_size(target_list);i++){
	var other_id = target_list[| i];
		
	//dont target self. This shouldn't happen regardless considering how the collision circle list works
	if (other_id = id) continue;
		
	//Check faction relation
	var _relation = GetNPCRelation(other_id.id);
		
	if(_relation == relation.enemy){
		var dist = point_distance(x,y,other_id.x,other_id.y);
		
		//if closer than the previous closest, set as target
		if (dist < nearest_dist){
			nearest_dist = dist;
			target = other_id;
		}
	}
		
}
ds_list_destroy(target_list);

//show_debug_message(ai_state);

switch (ai_state) {
	case "docile":
	
		#region old player relation checker
		/*
		if (instance_exists(oPlayer)){ // probably can get rid of this, for testing
			//If this NPC doesn't like the player and is close to them, aggro
			 if (relation_to_player == relation.enemy && point_distance(x, y, oPlayer.x, oPlayer.y) < 150) {
	            ai_state = "aggressive"; // Attack enemies
				moveDir = 0;
	        } 
		} */
		#endregion
		
		
		//normal idling behavior if not a stationary NPC
		if (!stationary && array_length(action_queue) == 0){
			//show_debug_message("working")
			QueueAction("left", irandom_range(15, 30));  // Walk left
		    QueueAction("idle", irandom_range(70, 205));  // Stop
		    QueueAction("right", irandom_range(15, 30)); // Walk right
		    QueueAction("idle", irandom_range(70, 205));   // Stop (last action must be sequential)
		}
		
		// check to see if we haven't strayed far from home.
		var distance_from_start = abs(x-xstart);
		// If too far, switch to returning state
        if (distance_from_start > wander_range) {
            ai_state = "returning";
            ActionBreak(); // Clear current actions to prioritize returning
        } 
		//run this code in most peaceful states
		if (target != noone){
			ai_state = "aggressive";
			ActionBreak();
		}
		#region legacy
		/*
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
		*/
		#endregion
	break;
	
	case "returning":
		// Move towards the starting point
        if (x < xstart-8) { //the 8 is a buffer so that the else condition can have a real range instead of being an exact point
            QueueAction("right", irandom_range(15,30), true);
        } 
        else if (x > xstart+8) {
            QueueAction("left", irandom_range(15,30), true);
        } else {
            // Reached starting point, go back to docile state
            ai_state = "docile";
            ActionBreak(); // Clear actions to reset behavior
        }
		
		//if target shows up
		if (target != noone){
			ai_state = "aggressive";
			ActionBreak();
		}
	
	break;
	
	case "aggressive":
		image_blend = c_red;
		
		if (!instance_exists(target)) {
	        ActionBreak();
	        ai_state = "docile";
	        target = noone;
	        break;
		}
		
		var dist_to_target = point_distance(x, y, target.x, target.y);
		
		 // Face the target
	    if (x < target.x) {
	        face = 1;  // Face right
	    } 
	    else if (x > target.x) {
	        face = -1; // Face left
	    }
		
	    // Move towards target
	    if (dist_to_target > 20 && dist_to_target <= aggro_wander_range) {
			aggro_timer = 0;
	        if (x < target.x) {
	            QueueAction("right", 1, false);
	        }
	        else if (x > target.x) {
	            QueueAction("left", 1, false);
	        }
	    } else if (dist_to_target <=20) { //within attack range
	        // If close enough, attack
	        QueueAction("attack", 1, false); // Assuming 30 frames for attack duration
	    } else {
			aggro_timer++
			if (aggro_timer >= aggro_time){
				ActionBreak();
				ai_state = "docile";
				target = noone;
			}
		}
	break;
	
	case "dead":
	break;

}


#endregion
switch (state) {
	case "free":
		
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
		
		///////////////////////////////
		// Check for agileKey tap
		if (agileActionStart) {
		    agileTapTimer = agileTapBuffer;
			
		}

		// Decrement timer if it's active
		if (agileTapTimer > 0) {
		    agileTapTimer--;
		    // Check if key is released before timer ends (trigger backstep)
		    if (!agileAction) { // if there is a directional input the player should roll instead
		        
				// Check for roll input
		        if (leftAction || rightAction) {
		            isRolling = true;
		            isBackstepping = false;
					rollTimer = rollTime;
		            //invulnerable = true;
				} else {
					isBackstepping = true;
			        agileTapTimer = 0;
					backstepTimer = backstepTime; //timer start
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
		
		NPC_collisions_movement(); //moved to the bottom
		
		
		//////////////////////////////
		

	break;
	
	case "attack":
		sprite_index = attack0Spr;
		NPC_attack_damage(attackDamage,attackDamageType);
		
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
	case "dead":
	sprite_index=deathSpr;
	if (image_index>=image_number-1){image_speed=0;};
	
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