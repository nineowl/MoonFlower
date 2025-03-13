if instance_exists(oPlayer){
	face = oPlayer.face;
} else {instance_destroy();}
if (face != 0) image_xscale = face;
x=oPlayer.x;
y=oPlayer.y;