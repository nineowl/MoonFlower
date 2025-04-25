//getControlsNPC();


//sets face
if (face != 0) image_xscale = face;



#region interaction code
//originally in create event, but needs to be in step event. Gets amount of dialogues
textMax = array_length(text_id); // Get the maximum text entries
cycleMax = array_length(cycle_id); //same as above but for cycle mode

//If player pressed interact button
if (interactEvent){
	if(state!="dead" && ai_state == "docile"){
		if (text_id[0] != ""){
			if (!cycleMode){
				myTextbox = create_textbox(text_id[text_index]);
				myTextbox.creatorID = id;
	

			} else {
				myTextbox = create_textbox(cycle_id[cycle_index]);
				myTextbox.creatorID = id;
			}
		}
	} else if (state="dead"){
		if (corpse_text!=""){
			create_textbox(corpse_text);
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
				if (current_actions[$ action].duration == current_actions[$ action].durationMax) {jumpActionStart=true;} else {jumpActionStart=false;}
				break;
				
			case "attack":
                attackAction = true;
                if (current_actions[$ action].duration == current_actions[$ action].durationMax) {attackActionStart=true;} else {attackActionStart=false;}
                break;
				
			case "agile":
                agileAction = true;
                if (current_actions[$ action].duration == current_actions[$ action].durationMax){agileActionStart=true;} else {agileActionStart=false;}
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
/*
if keyboard_check_pressed(ord("B")){
	//QueueAction("jump",1);
			//QueueAction("right",30)
			//QueueAction("idle",50)
			//QueueAction("left",20)
			//QueueAction("idle",60)
			//QueueAction("jump",1,false)
			//("right",40)
			//QueueAction("idle",60)
			//QueueAction("right",20,false);
			ActionBreak();
			//QueueAction("right",30,false)
			QueueAction("agile",1);
			QueueAction("idle",50)
			

}
debugging  */
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

if(target){
	if (target.state="dead"){target=noone;};
}

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
		/*
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
		} */
		
		
	    if (!instance_exists(target)) {
	        ActionBreak();
	        ai_state = "docile";
	        target = noone;
	        break;
	    }

	    var dist_to_target = point_distance(x, y, target.x, target.y);
	    var attack_range = 20; // Adjust attack range as needed
	    var dodge_chance = 14; // % chance to dodge
	    var reposition_chance = 10; // % chance to back off before attacking

	    // Face the target
	    if (x < target.x) face = 1;
	    else if (x > target.x) face = -1;
		
		/*
	    // Random chance to reposition instead of attacking immediately
	    if (dist_to_target <= attack_range && irandom(100) < reposition_chance) {
	        QueueAction("idle", irandom_range(10, 30), true); // Small pause before attacking
	    }
		*/
		/*
	    // Attack logic with cooldown
	    if (dist_to_target <= attack_range && attack_timer <= 0) {
	        QueueAction("attack", 1, true);
	        attack_timer = attack_cooldown; // Reset attack cooldown
	    }
		*/
	
	    // Move towards target but not constantly
	    if (dist_to_target > attack_range && dist_to_target <= aggro_wander_range) {
	        aggro_timer = 0;
			if (x < target.x) QueueAction("right", 1, true);
	        else if (x > target.x) QueueAction("left", 1, true);
	        if (irandom(1000) > 998) { // .2% chance to stop
	            QueueAction("idle",20);
	        }
	    }
		
		/*
	    // Random chance to dodge when player attacks
	    if (target.attackStart && (irandom(100) < dodge_chance)) {
			ActionBreak();
	        QueueAction("agile", 1, false);
			QueueAction("idle", backstepTime, true);
			show_debug_message("Dodging")
	    } 
		*/
		
		// Only attack if not already attacking
		if (!isAttacking && target != noone && attack_timer <= 0) {
		    var dist = point_distance(x, y, target.x, target.y);
    
		    if (dist <= attackRange && abs(target.x - x) > minAttackDistance) {
		        // Face the target before attacking
		        face = sign(target.x - x);

		        // Commit to the attack
		        isAttacking = true;
				attack_timer = attack_cooldown; // Start cooldown
		        ActionBreak();
		        QueueAction("attack", 1, true);
		    }
		}
		
		
		if (instance_exists(target.myHitBox)) {
		    var hitbox = target.myHitBox;
			var dist = point_distance(x, y, hitbox.x, hitbox.y);
			
			if (hitbox.image_alpha > 0 && reaction_timer <= 0) { 
			    reaction_timer = irandom_range(3, 6); // Small delay before dodging
			}

			if (reaction_timer > 0 ) {
			    reaction_timer--;
			    if (reaction_timer == 0 && lastDodgedAttack != hitbox.id && irandom(100) < dodge_chance && dist <= dodgeRange ) {
					lastDodgedAttack = hitbox.id; // Store the ID to prevent re-triggering
			        ActionBreak();
					QueueAction("idle",5,true);
			        QueueAction("agile", 1, false);
			        QueueAction("idle", backstepTime+30, true);
					show_debug_message("Dodging")
			    }
			}
			
		}
		
	    // Lose aggro after some time if out of range
	    if (dist_to_target > aggro_wander_range) {
	        aggro_timer++;
	        if (aggro_timer >= aggro_time) {
	            ActionBreak();
	            ai_state = "docile";
	            target = noone;
	        }
	    }

	    // Reduce attack cooldown over time
	    if (attack_timer > 0) attack_timer--;
		
	break;
	
	case "dead":
	break;

}


#endregion
switch (state) {
	case "free":
		isAttacking=false;
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
		
		NPC_dodge();
		
		NPC_collisions_movement(); //moved to the bottom
		

	break;
	
	case "attack":
		sprite_index = attack0Spr;
		NPC_attack_damage(attackDamage,attackDamageType);
		NPC_dodge();
		
		//if animation ends
		if animation_end() {
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
		sprite_index=hurtSpr;
		if animation_end() {
			state="free";
		};
		NPC_x_collision();
		NPC_y_collision();
		//Makes sure that body doesn't freeze midair
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
	case "dead":
		sprite_index=deathSpr;
		if (animation_end()){image_speed=0;};
		NPC_x_collision();
		NPC_y_collision();
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
	
}


#region damage related

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
}if (equippedFlower == noone){
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
			
			if(state!="dead"){ flashAlpha = 1;};
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
		}
		// Reset damage values
	    damage = 0;
	    damageType = "none";
	    damageEvent = false;
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