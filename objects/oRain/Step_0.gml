//Fall down
y+=fallSpd;


//check if touching ground

if place_meeting(x,y,oWall) || place_meeting(x,y,oSemiSolidWall){
	fallSpd=0;
	sprite_index=sRainSplash;
}

if sprite_index==sRainSplash && image_index>=(image_number-1){
	instance_destroy();
}