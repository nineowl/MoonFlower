var _camx = camera_get_view_x(view_camera[0]);
var _camy = camera_get_view_y(view_camera[0]);

var _p0 = .9; //Parallax constant
var _p1 = .8;
var _p2 = .76;
var _p3 = .71;
var _p4 = .67;

draw_sprite(bg03,0,_camx*_p0,_camy*_p0);
draw_sprite(bg03,1,_camx*_p1,_camy*_p1);
draw_sprite(bg03,2,_camx*_p2,_camy*_p2);
//draw_sprite(bg03,3,_camx*_p3,_camy*_p3);
//draw_sprite(bg03,4,_camx*_p3,_camy*_p4);
