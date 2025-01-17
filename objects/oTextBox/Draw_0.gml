//get controls
getControls();


textbox_x=camera_get_view_x(view_camera[0]);


textbox_y=camera_get_view_y(view_camera[0])+160;

//setup

if setup==false {
	setup=true;
	draw_set_font(global.font_main);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	
	//loop through pages
	///page_number = array_length(text); //now redundant
	for (var p=0;p<page_number;p++){
		
		//find how many characters are on each page and store that number in the "text_length" array
		text_length[p] = string_length(text[p]);
		
		//get the x position of the text box
		text_x_offset[p]=48;
	}
}

//typing the text
if draw_char < text_length[page] {
	draw_char += text_spd;
	draw_char = clamp(draw_char,0,text_length[page])
}

//flip through pages
if interactKeyPressed {

	//if the typing is done
	if draw_char == text_length[page] {
		//next page
		if page < page_number-1 {
			page++;
			draw_char=0;
		} else { //destroy textbox
			
			//link text for options
			if option_number > 0 {
			 create_textbox(option_link_id[option_pos]);
			}
			if (creatorID){ // This is used to help objects creating the textbox determine if end of text was reached
				creatorID.nextFlag = true;
				
				with(creatorID){
					if (text_index>=textMax-1){ //Once dialogue is exhausted, dialogue mode changes for the dialogue creator
						cycleMode = true;
					}
				}
			}
			
			instance_destroy();
		
		}
	} else { //if not done typing
		draw_char=text_length[page];
	}

}


//debug
//draw_text(textbox_x+240,textbox_y+50,textbox_x);




//draw the textbox
var _txtb_x = textbox_x+text_x_offset[page];
var _txtb_y = textbox_y;
txtb_img += txtb_img_spd;
txtb_spr_w = sprite_get_width(txtb_spr);
txtb_spr_h = sprite_get_height(txtb_spr);
//back of the textbox
draw_sprite_ext(txtb_spr,txtb_img,_txtb_x,_txtb_y, textbox_width/txtb_spr_w, textbox_height/txtb_spr_h,0,c_white,1);


//options
if draw_char == text_length[page] && page == page_number-1{
	
	//option selection
	option_pos += downKeyPressed-upKeyPressed;
	option_pos = clamp(option_pos,0,option_number-1);
	
	//draw potions
	var _op_space = 36; //retest value if font changes
	var _op_bord = 4;
	for (var op=0;op<option_number;op++){
		//the option box
		var _o_w = string_width(option[op]) + _op_bord*2;
		draw_sprite_ext(txtb_spr,txtb_img,_txtb_x+16,_txtb_y - _op_space*option_number+ _op_space*op, _o_w/txtb_spr_w,(_op_space-1)/txtb_spr_h,0,c_white,1);
		
		//the arrow
		if option_pos == op{
			draw_sprite(sMenuArrow,0,_txtb_x,_txtb_y - _op_space*option_number+ _op_space*op);
		}
		
		
		//the option text
		draw_text(_txtb_x+16+_op_bord,_txtb_y - _op_space*option_number+ _op_space*op-4, option[op]); //retest the y offset if the font changes.
	}
}



//draw the text

var _drawtext = string_copy(text[page],1,draw_char);
draw_text_ext(textbox_x+centerXOffset,_txtb_y+centerYOffset,_drawtext,line_sep,line_width)

//draw_text_ext(_txtb_x+border+centerXOffset,_txtb_y+centerYOffset,_drawtext,line_sep,line_width) // look better when you don't add the border to y, but may change depending on font