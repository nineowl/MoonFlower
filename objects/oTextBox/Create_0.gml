//controls setup
controlsSetup();

//Text Box parameters//
textbox_width=367;
textbox_height=100;
border=8;
line_sep=18;
line_width=textbox_width - border*2;
txtb_spr = sMenu;
txtb_img = 0;
txtb_img_spd = 6/60;

//the text;
page=0;
page_number=0;
text[0] = "";


text_length[0]=string_length(text[0]);
draw_char=0;
text_spd=1;
//options
options[0] = "";
option_link_id[0] = -1;
option_pos = 0;
option_number = 0;


setup=false;

//Center Offsets
centerXOffset = camera_get_view_width(view_camera[0])/2;  //180;
centerYOffset = 50;

//Records object that created this
creatorID = noone;