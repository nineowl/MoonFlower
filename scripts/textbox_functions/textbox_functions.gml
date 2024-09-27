/// @param text
function scr_text(_text){
	
	text[page_number] = _text;
	page_number++;

}

/// @param option
/// @param link_id

function scr_option(_option, _link_id) {
	
	option[option_number] = _option; //option number is initialized in oTextBox at 0.
	option_link_id[option_number] = _link_id; // while this value is initialized at -1, it will take in a string value that refers it to the game_text switch case
	
	option_number++;
	
}



/// @param text_id
function create_textbox(_text_id){
	
	with( instance_create_depth(0,0,-9999,oTextBox) ) {
		game_text(_text_id);
	}
	
}