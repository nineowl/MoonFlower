//fullscreen toggle
if keyboard_check_pressed(ord(9)){
	window_set_fullscreen(!window_get_fullscreen());
}

//Exit if there is no player
if !instance_exists(oPlayer) exit;

//Get Camera size
var _camWidth = camera_get_view_width(view_camera[0]);
var _camHeight = camera_get_view_height(view_camera[0]);

//Get Camera target coordinates
var _camX = oPlayer.x - _camWidth/2;
var _camY = oPlayer.y - _camHeight/2;

//Constrain camera to room borders
_camX = clamp(_camX,0,room_width-_camWidth);
_camY = clamp(_camY,0,room_height-_camHeight);

//Set cam Coordinate variables
finalCamX+=(_camX-finalCamX)*camTrailSpd;
finalCamY+=(_camY-finalCamY)*camTrailSpd;

//Set Camera Coordinates
camera_set_view_pos(view_camera[0],finalCamX,finalCamY);