//Properties
HP = 10;
equippedFlower = noone;
damage = 0; //amount of incoming damage
damageType = "none" //type of incoming damage
immortal=false;

//events
damageEvent = false;
interactEvent = false;
myHitBox = noone;

poise=0;
poiseMax=0;
poiseTime=300; //5 seconds
poiseTimer=0;
poiseDamage=0; //incoming poise damage.


//Shader related
flashAlpha=0;
flashColor=c_red;

#region dialogue variables
//dialogue functionality
text_id[0] = "";
text_index = 0;
death_text = "";// "004"; //initially default death text, but it's a bit much
corpse_text = "";// if you interact with it's corpse
nextFlag = false; //This checks if dialogue reaches last page. If it does, this value is set to true in the textbox object.

cycle_id[0] = ""; // Id of cycling text. Could be one id, leading to exhaustiv text.
cycle_index = -1; //This feels risky, but the way we switch the cycle mode increments the index

cycleMode = false; //It' set to true once all dialogue is exhausted.
cycleType = false; //False - Ordered, True - Random;
lastCycle = -1; // starts at -1 since it gets incremented on cyclemode activation. A bit risky, maybe there's another way.


myTextbox = noone; //initialize this variable
talkRange = 60; //When this distance is passed, textboxes are destroyed
#endregion
#region Movemnt & Collision

//Movement & Collision
xspd = 0;
yspd = 0;
moveSpd[0] = 2;
moveSpd[1] = 3.5;
face = 1; //-1 left, 1 right
moveDir = 0; //-1 left, 0, 1 right

//dodging
agileTapTimer = 0;
agileTapBuffer = 20; // Number of frames to consider as a tap
isBackstepping = false;
backstepTimer = 0;
backstepTime = 5; // Number of frames for the backstep
backstepSpeed = 4;
invincible = false; // Optional: If you want invulnerability during the backstep
invincibilityTimer=0;
invincibilityTime=4;
invincibilityBuffer=4;
invincibilityBufferFrames=4;


isRolling = false;
rollSpeed = 4;
rollTime = 8;
rollTimer = 0;

	//Jumping
	grav = .275;
	termVel = 4;
	onGround=true;
	jumpMax=2;
	jumpCount=0;
	jumpHoldTimer=0;
		//Jump values for each successive jump
		jumpHoldFrames[0]=18;
		jspd[0] =  -3.05;
		jumpHoldFrames[1]=10;
		jspd[1] =  -2.05;
		
	//Coyote Time
	//Hang Time
	coyoteHangFrames=3;
	coyoteHangTimer=0;
	//Jump buffer time
	coyoteJumpFrames=6;
	coyoteJumpTimer=0;
	
//Jump Action Variables - Act like the key presses used for the player
	jumpBufferTime=3;
	jumpBuffered=false;
	jumpBufferTimer=0;
	
	jumpActionStart=false; //always starts with jump action
	jumpAction=false;

	

//Moving Platforms
myFloorPlat=noone;
earlyMoveplatXspd=false;
downSlopeSemiSolid=noone;
forgetSemiSolid=noone;
moveplatXspd=0;
moveplatMaxYspd=termVel; //feel free to change if needed.

//Functions for NPC relating to movement and collision
function setOnGround(_val=true){
	if _val==true{
		onGround=true;
		coyoteHangTimer=coyoteHangFrames;
	}else{
		onGround=false;
		myFloorPlat=noone;
		coyoteHangTimer=0;
	}
}

function checkForSemisolidPlaform(_x,_y){
	//create a return variable
	var _rtrn=noone;
	//We must not be moving upwards and then we check for a normal collision
	if yspd>=0 && place_meeting(_x,_y,oSemiSolidWall){
		//Create a ds list to store all colliding instances of oSemiSolidWall
		var _list = ds_list_create();
		var _listSize = instance_place_list(_x,_y,oSemiSolidWall,_list,false);
		
		//Loop through the colliding instances and only return one if it's top is below the player
		for(var i=0;i<_listSize;i++){
			var _listInst=_list[| i];
			if _listInst != forgetSemiSolid && floor(bbox_bottom) <= ceil(_listInst.bbox_top-_listInst.yspd){
				_rtrn= _listInst;
				//Exit the loop early
				i=_listSize;
			}
		}
		
		//destroy ds list to free memory
		ds_list_destroy(_list);
	}
	
	//return our variable
	return _rtrn;
}

#endregion


//AI Related
//sets home for NPC, so if pathed away they can return.
homeX = x;
homeY = y;

homeIdleDist = 30; //max distance from home NPC will go if idle;
homeAggroDist = 60; //max distance from home NPC will go if aggro;

ledgeBuffer = 8 // how close it will get to the ledge


jumpTimer = 0;
jumpTime = 80;
randomJumpTimer=0;
randomJumpTime=60;


moveTimer = 0;
moveTime = 70; // in a way this indicates the maximum distance an NPC will travel while docile;
dirSet = false;
prevDir = 0;


//States
//Current state method uses a prev state for state returning
prevState = ""; //set this state on state changes
state = "free";


//faction = "neutral"; //default faction. Set this differently at 
// Personal relationships (override faction-based relations)
//personal_relations = ds_map_create();
//personal_relations[? oPlayer.id] = 0; // -1 = Hostile, 0 = Neutral, 1 = Friendly

//faction = global.factions_relations.echo;


personal_relations = [];
identifier = "default";
identifier = generate_identifier();
show_debug_message(string(identifier));
//show_message(identifier);

//array_push(personal_relations, new special_relation("player", relation.enemy));

///Testing with control of NPC
//control setup
controlsSetupNPC();

function controlsSetupNPC(){
	jumpBufferTime=3;
	jumpBuffered=0;
	jumpBufferTimer=0;
	
	
	//Direction Inputs
	rightAction = false;
	leftAction = false;
	downAction = false;
	upAction = false;
	
	downActionStart = false;
	upActionStart = false;
	
	
	//Action Inputs
	jumpActionStart = false;
	jumpAction = false;
		
	agileAction = false;
	agileActionStart = false;
		
	attackAction = false;
	attackActionStart = false;
	
}

function getControlsNPC(){
	//Direction Inputs
	rightAction = keyboard_check((ord("D"))) + gamepad_button_check(0,gp_padr);
		rightAction = clamp(rightAction,0,1);
	leftAction = keyboard_check((ord("A"))) + gamepad_button_check(0,gp_padl);
		leftAction = clamp(leftAction,0,1);
	downAction = keyboard_check((ord("S"))) + gamepad_button_check(0,gp_padd);
		downAction = clamp(downAction,0,1);
	upAction = keyboard_check((ord("W"))) + gamepad_button_check(0,gp_padu);
		upAction = clamp(upAction,0,1);
	
	downActionStart = keyboard_check_pressed((ord("S"))) + gamepad_button_check_pressed(0,gp_padd);
		downActionStart = clamp(downActionStart,0,1);
	upActionStart = keyboard_check_pressed((ord("W"))) + gamepad_button_check_pressed(0,gp_padu);
		upActionStart = clamp(upActionStart,0,1);
	
	
	//Action Inputs
	jumpActionStart = keyboard_check_pressed(vk_space) + gamepad_button_check_pressed(0, gp_face1);
		jumpActionStart = clamp(jumpActionStart,0,1);
	jumpAction = keyboard_check(vk_space) + gamepad_button_check(0, gp_face1);
		jumpAction = clamp(jumpAction,0,1);
		
	agileAction = keyboard_check(vk_lshift)+gamepad_button_check(0,gp_face3);
		agileAction = clamp(agileAction,0,1);
	agileActionStart = keyboard_check_pressed(vk_lshift)+gamepad_button_check_pressed(0,gp_face3);
		agileActionStart = clamp(agileActionStart,0,1);
		
	attackAction = keyboard_check(ord("N"));
		attackAction = clamp(attackAction,0,1);
	attackActionStart = keyboard_check_pressed(ord("N"));
		attackActionStart = clamp(attackActionStart,0,1);
		
		/*
	interactKey = keyboard_check(ord("J"));
		interactKey = clamp(interactKey,0,1);
	interactKeyPressed = keyboard_check_pressed(ord("J"));
		interactKeyPressed = clamp(interactKeyPressed,0,1);
		
	
	//Menu Inputs
	enterKey = keyboard_check(vk_enter) + gamepad_button_check(0,gp_start);
		enterKey = clamp(enterKey,0,1);
	enterKeyPressed = keyboard_check_pressed(vk_enter) + gamepad_button_check_pressed(0,gp_start);
		enterKeyPressed = clamp(enterKeyPressed,0,1);
	
	*/
		
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
	

}


//Attack Related
//Attack related
hitByAttack = ds_list_create();
//damage = 2;
attackDamage=1;
attackDamageType="normal";


//Logic State Machine
ai_state = "docile";
target = noone;
wander_range = 100;
aggro_wander_range = 200;
aggro_range = 50;
aggro_timer = 0;
aggro_time = 200;
stationary = false; // determines if this NPC will move or not while docile;

faces = 0; //Left, Right, or None. Used to make NPC return to facing a direction if stationary and docil.
faceresettime = 300;
faceresettimer = 0;

attack_timer=0;
attack_cooldown=45;

isAttacking=false;
attackRange=22;
minAttackDistance=1;

reaction_timer=0;
lastDodgedAttack=noone;
dodgeRange=24;


//action handling
action_queue = []; //{};
action_queue[0] = {};
action_count = 0;



/*NOTE: when queueing actions, if you're doing simultaneous actions, the last action has to be sequential*/
function QueueAction(action_name, frames, sequential = true){
		
		// Ensure action_queue[action_count] exists as a struct
	    if (!array_length(action_queue) || action_count >= array_length(action_queue)) {
	        action_queue[action_count] = {}; // Create an empty struct at this index
	    }

	    // Add action to the struct
	    action_queue[action_count][$ action_name] = { 
			duration: frames, 
			durationMax: frames};
		
		
		//if sequenced move up to next action
		if (sequential) {
			action_count++;
			action_queue[action_count] = {} // prepare next step
		}
		
}
function ActionBreak(){
	action_queue = [];
    action_count = 0;
}


#region old
/*
function QueueAction(action_name, frames) {
    action_queue[$ action_name] = frames; 
} */



/*
function QueueAction(action_name, frames, is_sequential = true) {
    action_queue[$ action_name] = {
        duration: frames,
        sequential: is_sequential
    };
}
*/
/*
function QueueAction(action_name, frame, is_sequential=true) {
    var new_action = {
        _name: action_name,
        duration: frame,
        sequential: is_sequential
    };

    //array_push(action_queue, new_action); // Add the new action to the queue
	action_queue[array_length(action_queue)] = new_action; // Append to array properly
}
*/

#endregion

//Please be sure to destroy any object created by this object upon it's own destruction unless that object has no dependencies.