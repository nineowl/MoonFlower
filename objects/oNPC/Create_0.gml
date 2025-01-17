HP = 10;
invincible = false;

damageEvent = false;

interactEvent = false;


//Shader related
flashAlpha=0;
flashColor=c_red;


//dialogue functionality
text_id[0] = "";
text_index = 0;

nextFlag = false;

cycle_id[0] = ""; // Id of cycling text. Could be one id, leading to exhaustiv text.
cycle_index = -1; //This feels risky, but the way we switch the cycle mode increments the index
cycleMax = array_length(cycle_id);

cycleMode = false; //It' set to true once all dialogue is exhausted.
cycleType = false; //False - Ordered, True - Random;
lastCycle = -1;


myTextbox = noone; //initialize this variable

talkRange = 60;




/*

Interact types

no dialogue - if text_id = "";

exhaustive dialogue - dialogue repeats at the last text id. Exhaustive could lead into cycling

cycling dialogue - dialogue cycles between

single dialogue - one line of dialogue

give flower/mushroom? - we'll try this later.




*/