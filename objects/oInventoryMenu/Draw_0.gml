x=camera_get_view_width(0)- 3*room_width/4;
y=camera_get_view_height(0)- 3*room_height/4;


//draw menu background

draw_sprite_ext(sprite_index,image_index,x,y, width/sprite_width,height/sprite_height,0,c_white,1);


//draw the options
draw_set_font(global.font_main);
draw_set_valign(fa_top);
draw_set_halign(fa_left);
for (var i=0;i<op_length;i++){
	draw_text(x+op_border,y+ op_border + op_space*i,option[i]);
}