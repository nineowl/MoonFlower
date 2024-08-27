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
jumpSpr=sPlayerJump;
crouchSpr=sPlayerCrouch;
crawlSpr=sPlayerCrawl

//Moving
face = 1; //-1 left, 1 right
moveDir = 0; //-1 left, 0, 1 right
runType = 0;
moveSpd[0] = 2;
moveSpd[1] = 3.5;
xspd = 0;
yspd = 0;

//State Variables
crouching=false;

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


//Moving Platforms
myFloorPlat=noone;
earlyMoveplatXspd=false;
downSlopeSemiSolid=noone;
forgetSemiSolid=noone;
moveplatXspd=0;
moveplatMaxYspd=termVel; //feel free to change if needed.
crushTimer=0;
crushDeathTime=3;