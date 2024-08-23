dropTimer++;

if freqSet==false {dropFreq = random_range(freqMax,freqMin); freqSet=true;};

if (dropTimer >= dropFreq){
	instance_create_depth(random_range(x-variance,x+variance),y,depth,oRain,{fallSpd});
	dropTimer=0;
	freqSet=false;
}