if (HP <= 0 && !invincible){
	instance_destroy();
}



//Flash
if (damageEvent){
	flashAlpha = 1;
}
//reduce flash
if (flashAlpha>0){
	flashAlpha-=.05;
}



//Damage event code should be reset every frame.
damageEvent = false;


//originally in create event, but needs to be in step event. Gets amount of dialogues
textMax = array_length(text_id); // Get the maximum text entries
cycleMax = array_length(cycle_id); //same as above but for cycle mode

//If player pressed interact button
if (interactEvent){
	
	if (!cycleMode){
		myTextbox = create_textbox(text_id[text_index]);
		myTextbox.creatorID = object_index;
	

	} else {
		myTextbox = create_textbox(cycle_id[cycle_index]);
		myTextbox.creatorID = object_index;
	}
	
	
	interactEvent = false;
	
} 

if (myTextbox){
	if (distance_to_object(oPlayer)>talkRange){

		with(myTextbox){
			instance_destroy();
		}
	}
	

}

if (nextFlag){
	if(!cycleMode){
		if (text_index<textMax-1){
			text_index++;
		}
	} else {
		if (!cycleType){ //If cycling is ordered
			cycle_index++;
			if (cycle_index>=cycleMax){
				cycle_index = 0;
			}
			//show_message(cycleMode);
		} else { //if cycling is random
			cycle_index = irandom(cycleMax-1);
			if (cycleMax-1 !=0){
				while (cycle_index = lastCycle){ //Makes sure you don't repeat the last dialogue
					cycle_index = irandom(cycleMax-1);
				}
			}
			
			lastCycle = cycle_index;
			//There is one caveat. If the cycle and non cycle dialogues are the same, it could repeat a dialogue on the first time. Not worth it to me to figure out how to deal with it.
		}
	}
	

	
	nextFlag = false;
}


//UPDATE THIS, this is barebones

/* if the array index is less than the array length, increment the index.
if the cycle_id does not equal "" and the array index = the array length,
create a texbox using the cycle_id and increment the cycle id(stop once it's max). */