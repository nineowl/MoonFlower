if (HP <= 0 && !invincible){
	instance_destroy();
}



//Flash
if (damageEvent){
	flashAlpha = 1;
}
//reduce flash
if (flashAlpha>0){
	flashAlpha-=.05;
}



//Damage event code should be reset every frame.
damageEvent = false;