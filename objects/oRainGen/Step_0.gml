dropTimer++;

if freqSet==false {dropFreq = random_range(freqMax,freqMin); freqSet=true;};


if (outside=true){ //to allow for rain overlay
	if (dropTimer >= dropFreq){
		instance_create_depth(random_range(x-variance,x+variance),y,depth,oRain,{
			fallSpd,
			rainLayer : choose(-1,0,1)
			});
		dropTimer=0;
		freqSet=false;
	}
} else {
	if (dropTimer >= dropFreq){
		instance_create_depth(random_range(x-variance,x+variance),y,depth,oRain,{fallSpd});
		dropTimer=0;
		freqSet=false;
	}
}