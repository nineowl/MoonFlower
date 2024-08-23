xStart=0;
xEnd=room_width;
setVariance = 40;

while(xStart<xEnd){
	instance_create_depth(xStart,0,depth,oRainGen,{
	freqMin,
	freqMax,
	variance,
	fallSpd
	});
	xStart+=irandom_range(1,setVariance);
}