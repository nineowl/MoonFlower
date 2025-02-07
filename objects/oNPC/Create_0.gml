//Properties
HP = 10;
invincible = false;


//events
damageEvent = false;
interactEvent = false;


//Shader related
flashAlpha=0;
flashColor=c_red;

#region dialogue variables
//dialogue functionality
text_id[0] = "";
text_index = 0;
death_text = "004";

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
moveSpd = 2//1;
face = 1; //-1 left, 1 right
moveDir = 0; //-1 left, 0, 1 right


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
stationary = false; // determines if this NPC will move or not while docile;

//States
//Current state method uses a prev state for state returning
prevState = ""; //set this state on state changes
state = "docile";


faction = "neutral"; //default faction. Set this differently at 
// Personal relationships (override faction-based relations)
//personal_relations = ds_map_create();
//personal_relations[? oPlayer.id] = 0; // -1 = Hostile, 0 = Neutral, 1 = Friendly

//faction = global.factions_relations.echo;


personal_relations = [];

identifier = generate_identifier();
//show_message(identifier);

//array_push(personal_relations, new special_relation("player", relation.enemy));

//show_message(personal_relations[0])

//Please be sure to destroy any object created by this object upon it's own destruction unless that object has no dependencies.