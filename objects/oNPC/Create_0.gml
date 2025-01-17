//Properties
HP = 10;
invincible = false;


//events
damageEvent = false;
interactEvent = false;


//Shader related
flashAlpha=0;
flashColor=c_red;


//dialogue functionality
text_id[0] = "";
text_index = 0;
death_text = "004";

nextFlag = false; //This checks if dialogue reaches last page. If it does, this value is set to true in the textbox object.

cycle_id[0] = ""; // Id of cycling text. Could be one id, leading to exhaustiv text.
cycle_index = -1; //This feels risky, but the way we switch the cycle mode increments the index

cycleMode = false; //It' set to true once all dialogue is exhausted.
cycleType = false; //False - Ordered, True - Random;
lastCycle = -1; // starts at -1 since it gets incremented on cyclemode activation. A bit risky, maybe there's another way.


myTextbox = noone; //initialize this variable
talkRange = 60; //When this distance is passed, textboxes are destroyed



//Movement & Collision
xspd = 0;
yspd = 0;
moveSpd = 1;
face = 1; //-1 left, 1 right
moveDir = 0; //-1 left, 0, 1 right

moveTimer = 0;
moveTime = 40;
dirSet = false;

//Please be sure to destroy any object created by this object upon it's own destruction unless that object has no dependencies.