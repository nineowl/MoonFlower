#region damage related
if (HP <= 0 && !invincible){
	if (myTextbox){
		with (myTextbox) {
			instance_destroy();
		}
	}
	create_textbox(death_text); //death dialogue. Later you may have to send this data to an external game object that keeps a list of deaths to prioritize death dialogue in the case of multiple simultaneous deaths. Or implement timer. Or both.
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
	
	if (!cycleMode){
		myTextbox = create_textbox(text_id[text_index]);
		myTextbox.creatorID = object_index;
	

	} else {
		myTextbox = create_textbox(cycle_id[cycle_index]);
		myTextbox.creatorID = object_index;
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

xspd = moveDir * moveSpd;


//quick set up for idle movement. For test purposes
if (!dirSet){
	moveDir = choose(-1,0,1);
	dirSet = true;
} else {
	moveTimer++;
	if (moveTimer >= moveTime){
		moveTimer=0;
		dirSet=false;
		}
}

	//Get my face
		if moveDir!=0{face=moveDir;};

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


x += xspd; //make sure this happens after collision code

if (xspd = 0) {
		sprite_index=idleSpr
	} else {
		sprite_index=walkSpr
	}