//Move in a circle
dir+=rotSpd;

//Get our target positions
var _targetX = xstart + lengthdir_x(radius,dir);
var _targetY = ystart + lengthdir_y(radius,dir);

//Get our xspd and yspd
xspd=_targetX-x;
yspd=0 //_targetY-y;

//move
x+=xspd;
y+=yspd;