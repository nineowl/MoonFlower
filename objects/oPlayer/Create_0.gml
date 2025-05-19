//States + Properties
equippedFlower = noone;

//Inventory
inventory=[];

//Attack related
hitByAttack = ds_list_create();
knifeDamage = 2;

damageEvent = false;
damage=0;
immortal=true;
reviveTimer=300;
reviveTime=300;

poise=0;
poiseMax=0;
poiseTime=300; //5 seconds
poiseTimer=0;
poiseDamage=0; //incoming poise damage.

//HP = 10;

flashAlpha=0;
flashColor=c_red;

//Custom functions for player
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

//control setup
controlsSetup();

//Sprites
maskSpr=sPlayerIdle;
idleSpr=sPlayerIdle;
walkSpr=sPlayerWalk;
runSpr=sPlayerRun;
backStepSpr=sPlayerBackStep
rollSpr=sPlayerRoll;
jumpSpr=sPlayerJump;
crouchSpr=sPlayerCrouch;
crawlSpr=sPlayerCrawl
idleCrouchSpr=sPlayerIdleCrouch;
crouchIdleSpr=sPlayerCrouchIdle;
deathSpr=sPlayerDeath;
hurtSpr=sPlayerHurt
reviveSpr=sPlayerRise;
//attack sprites
knifeAttack0Spr=sPlayerKnifeAttack0;
knifeAttack1Spr=sPlayerKnifeAttack1;





crouchStart = false;  //might be retired

//Moving
face = 1; //-1 left, 1 right
moveDir = 0; //-1 left, 0, 1 right
runType = 0;
moveSpd[0] = 2;
moveSpd[1] = 3.5;
xspd = 0;
yspd = 0;

//dodging
agileTapTimer = 0;
agileTapBuffer = 20; // Number of frames to consider as a tap
isBackstepping = false;
backstepTimer = 0;
backstepTime = 8; // Number of frames for the backstep
backstepSpeed = 4;
invincible = false; // Optional: If you want invulnerability during the backstep
invincibilityTimer=0;
invincibilityTime=5;
invincibilityBuffer=5;
invincibilityBufferFrames=5;
//invincibility time and bufferframes should be equal. They are separated just in case, but they probably are fine as one value

isRolling = false;
rollSpeed = 4;
rollTime = 10;
rollTimer = 0;

//State Variables
crouching=false;//about to be retired

state = "free";

/*
enum STATE {
	
	idle,
	walk,
	run,
	crouch,
	crawl,
	jump,
	airborne,
	attack,

}

*/


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

	climbJumpTimer=30; //starts at max
	climbJumpTime=30;


//Moving Platforms
myFloorPlat=noone;
earlyMoveplatXspd=false;
downSlopeSemiSolid=noone;
forgetSemiSolid=noone;
moveplatXspd=0;
moveplatMaxYspd=termVel; //feel free to change if needed.
crushTimer=0;
crushDeathTime=3;




//AI Related
faction = "player";
identifier = "player";

//isAttacking=false;
attackStart=false;
myHitBox=noone;