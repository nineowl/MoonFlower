//delete itself and add to the butterfly count

if (place_meeting(x,y,oPlayer)){
	global.butterflies+=10;
	instance_destroy();
}