xStart=0;
xEnd=room_width;
setVariance = 40;

while(xStart<xEnd){
	instance_create_depth(xStart,0,depth,oRainGen,{
	freqMin,
	freqMax,
	variance,
	fallSpd,
	outside
	});
	xStart+=irandom_range(1,setVariance);
}

audio_play_sound(ambRain00,0,true,1.5);//play rain sounds