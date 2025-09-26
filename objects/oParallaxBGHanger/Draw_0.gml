var _camx = camera_get_view_x(view_camera[0]);
var _camy = camera_get_view_y(view_camera[0]);

var _p0 = .9; //Parallax constant
var _p1 = .88;
var _p2 = .84;
var _p3 = .8;
var _p4 = .78;
var _p5 = .76;
var _p6 = .74;

draw_sprite(bg,0,_camx*_p0,_camy*_p0);
draw_sprite(bg,1,_camx*_p1,_camy*_p1);
draw_sprite(bg,2,_camx*_p2,_camy*_p2);
draw_sprite(bg,3,_camx*_p3,_camy*_p3);
draw_sprite(bg,4,_camx*_p4,_camy*_p4);
draw_sprite(bg,5,_camx*_p5,_camy*_p5);
draw_sprite(bg,6,_camx*_p6,_camy*_p6);
