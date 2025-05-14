//x=camera_get_view_width(0)- 3*room_width/4;
//y=camera_get_view_height(0)- 3*room_height/4-36;




x=camera_get_view_x(view_camera[0])+ camera_get_view_width(view_camera[0])/4;
y=camera_get_view_y(view_camera[0])+ camera_get_view_height(view_camera[0])/8;


//draw menu background

draw_sprite_ext(sprite_index,image_index,x,y, width/sprite_width,height/sprite_height,0,c_white,1);

//draw the options
draw_set_font(fCurlyGirly);
draw_set_valign(fa_top);
draw_set_halign(fa_left);
for (var i=0;i<op_length;i++){
	_c = c_white;
	if (pos == i) _c = c_yellow;
	if(i=0){
		draw_text_color(x,y,option[i],_c,_c,_c,_c,1);
	} else {
		draw_text_color(x+ string_length(option[i-1])*10*i,y,option[i],_c,_c,_c,_c,1);
	}
}



_c= c_white;

switch (pos){
	case 0: // Flower
		flwr_pos += menuUpKeyPressed-menuDownKeyPressed;
		if (flwr_pos>=max_flwr) flwr_pos = 0;
		if (flwr_pos<0) flwr_pos = max_flwr-1;
		
	
		draw_set_font(fSimpleScript);
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);
		
		if (instance_exists(oPlayer)){
			if (array_length(oPlayer.inventory)>0){
				if(oPlayer.inventory[flwr_pos]){
					draw_sprite(sFlower0,0,x+op_border,y+pg_border+op_space)
					draw_text_color(x+op_border+200,y+pg_border+5,string(flwr_pos+1)+"/"+string(array_length(oPlayer.inventory)),_c,_c,_c,_c,1); //Tells you what you're scrolled on
					draw_text_color(x+op_border,y+pg_border+op_space,info_flwr[0]+ string(oPlayer.inventory[flwr_pos].petals),_c,_c,_c,_c,1); //how many petals
					draw_text_color(x+op_border,y+pg_border+op_space*2,info_flwr[1]+ oPlayer.inventory[flwr_pos].stemType,_c,_c,_c,_c,1); //type of stem
					draw_text_color(x+op_border,y+pg_border+op_space*3,info_flwr[2]+ oPlayer.inventory[flwr_pos].description,_c,_c,_c,_c,1); //description, need to learn how to wrap text
				
					if (oPlayer.inventory[flwr_pos].petals == 0) {
						draw_text_color(x+op_border,y+pg_border+op_space*4,"withered",_c,_c,_c,_c,1);
					}
				
					if (oPlayer.inventory[flwr_pos] == oPlayer.equippedFlower) {
						draw_text_color(x+op_border,y+pg_border+op_space*5,"equipped",_c,_c,_c,_c,1);
					}


					/*
					draw_text_color(x+op_border,y+pg_border+op_space,info_flwr[0]+ string(oPlayer.equippedFlower.petals),_c,_c,_c,_c,1); //how many petals
					draw_text_color(x+op_border,y+pg_border+op_space*2,info_flwr[1]+ oPlayer.equippedFlower.stemType,_c,_c,_c,_c,1); //type of stem
					draw_text_color(x+op_border,y+pg_border+op_space*3,info_flwr[2]+ oPlayer.equippedFlower.description,_c,_c,_c,_c,1); //description, need to learn how to wrap text
					*/
				}
			
				if (interactKeyPressed){
					if (oPlayer.equippedFlower == oPlayer.inventory[flwr_pos]){
						oPlayer.equippedFlower = noone;
					} else {
						oPlayer.equippedFlower = oPlayer.inventory[flwr_pos];
					}
				}
			}
		
		}
		
		
	break;
	case 1: // Consumables
	break;
	case 2: // Key Items
	break;
	case 3: // Game
		game_pos += menuUpKeyPressed-menuDownKeyPressed;

		if (game_pos<0) game_pos=info_game_length-1;
		if (game_pos>=info_game_length) game_pos=0;
	
		draw_set_font(fDirectMessage);
		draw_set_valign(fa_top);
		draw_set_halign(fa_middle);
		
		for (i=0;i<info_game_length;i++){
			_c=c_white;
			if (game_pos==i) _c = c_yellow;
			draw_text_color(x+camera_get_view_width(view_camera[0])/4,y+pg_border+i*op_space,info_game[i],_c,_c,_c,_c,1);
		}
		
		if (game_pos ==1 && interactKeyPressed) game_end();
		
	break;



}