textbox_x=camera_get_view_x(view_camera[0]);

textbox_y=camera_get_view_y(view_camera[0]);

draw_set_font(global.font_main);
draw_set_valign(fa_top);
draw_set_halign(fa_left);

drawtext="test"

if (oPlayer.equippedFlower){
	drawtext=oPlayer.equippedFlower.petals;
	
}

draw_text_ext(textbox_x+32,textbox_y,drawtext,8,100)
//draw_text_ext(textbox_x+32,textbox_y+16,"inventory",16,100)