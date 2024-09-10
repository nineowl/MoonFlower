//controls setup
controlsSetup();

//Text Box parameters//
textbox_width=367;
textbox_height=111;
border=8;
line_sep=12;
line_width=textbox_width - border*2;
txtb_spr = sMenu;
txtb_img = 0;
txtb_img_spd = 6/60;

//the text;
page=0;
page_number=0;
text[0] = "AYYYYYYYY";
text[1] = "Wasssuuuuup";
text[2] = "Yeah this is the game. Check it out. MOoonflower beotch";
text[3] = "I wanna be a competent gamedev";



text_length[0]=string_length(text[0]);
draw_char=0;
text_spd=1;

setup=false;

