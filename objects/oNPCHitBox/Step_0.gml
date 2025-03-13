if instance_exists(creatorID){
	face = creatorID.face;
} else { instance_destroy();}
if (face != 0) image_xscale = face;