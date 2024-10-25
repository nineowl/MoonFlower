//Fall down
y+=fallSpd;


//check if touching ground
/*
if place_meeting(x,y,oWall) || place_meeting(x,y,oSemiSolidWall) /*|| place_meeting(x,y,oPlayer)//{
	fallSpd=0;
	depth = 500;
	sprite_index=sRainSplash;
	
} */



if (sprite_index==sRainSplash && image_index>=(image_number-1)) || y > room_height {
	instance_destroy();
}