/// @param text_id
function game_text(_text_id){
	
	switch(_text_id){
	
	case "000":
		scr_text("ayyy");
		break;
	case "001":
		scr_text("testing it out.");
		scr_text("I hope it's looking good.");
		scr_text("how was your day?");
			scr_option("Good", "001 - good");
			scr_option("Eh", "001 - eh");
		break;
		case "001 - good":
			scr_text("noice");
			break;
		case "001 - eh":
			scr_text("Well the days not over yet!");
			break;
		
	case "002":
		scr_text("cyborg");
		scr_text("I am a cyborg");
		scr_text("that's okay");
		break;
		
	case "003":
		scr_text("<3");
		scr_text("luv you");
		scr_text("no really");
		break;
		
	case "004":
		scr_text("...");
		break;
		
	case "005":
		scr_text("STFU brindan");
		break;
		
	case "006":
		scr_text("My dad works at blizzard");
		break;
		
	case "007":
		scr_text("If you seek the moonflower,");
		scr_text("Journey to land of trumpets.");
		break;
		
	//The Cynic's Dialogue
	case "Cynic000":
		scr_text("Oh? Another nameless unborn...");
		scr_text("...");
		break;
	case "Cynic001":
		scr_text("Well, if you know what's good for you,");
		scr_text("You'd find a safe place to perch.");
		scr_text("This is my spot. I suggest you find another.")
		scr_text("Please.")
		break;
	
	}
}