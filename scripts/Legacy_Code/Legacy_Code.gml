// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Legacy_Code(){
	
	
	
#region crouching

//Crouching
	//Transition to crouch
		//Manual = onGround / Auto = placemeeting
		if onGround && (downKey || place_meeting(x,y,oWall)) {
			crouching=true;
		}
		/*//Forced / Automatic
		if onGround && place_meeting(x,y,oWall){
			crouching=true;
		} //*/
		//Change collision mask
		if crouching {mask_index=crouchSpr;};
		
	//Transition out of crouch
		//Manual !downKey / Auto = !onGround
		if crouching && (!downKey || !onGround) {
			//check if i CAN uncrouch
			mask_index = idleSpr;
			if !place_meeting(x,y,oWall){
				crouching=false;
			} else { //go back to crouching mask index if we can't uncrouch
				mask_index=crouchSpr;
			}
		}

#endregion

}