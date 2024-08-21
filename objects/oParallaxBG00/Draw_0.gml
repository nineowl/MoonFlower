var _camx = camera_get_view_x(view_camera[0]);
var _camy = camera_get_view_y(view_camera[0]);

var _p0 = .9; //Parallax constant
var _p1 = .7;

draw_sprite(bg01,0,_camx*_p0,_camy*_p0);
draw_sprite(bg01,1,_camx*_p1,_camy*_p1);