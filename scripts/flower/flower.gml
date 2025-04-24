// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function flower(){

}

//as you implement the next properties you must expand the constructor
function Flower(_petals, _type, _leaves, _thorns, _poisonous, _stemType, _phantompetals=0,_poiseMax=0) constructor {
    petals = _petals;          // Number of hits it can take
	phantom_petals = _phantompetals //Number of phantom petals
    type = _type;				//Determines appearance/effects
    leaves = _leaves;          // (Future: stamina if implemented)
    thorns = _thorns;          // True/false: has thorns?
    poisonous = _poisonous;    // True/false: poisonous effect?
    stemType = _stemType;      // Different stem types for variation
	
	poiseMax= _poiseMax;				//Depending on stemType;
	poiseTime=300;				//Default poise time, changes with stemType
	
    lifespan = 100;            // How long it lasts (if needed)
    age = 0;                   // Track its age (if needed)

    // Future properties
    glows = false;             // Does it glow in the dark?
    sweetNectar = false;       // Attracts creatures?
	
	if (poiseMax=0){	//if poise isn't preset on creation
		switch(stemType){
			case "Slender":
				poiseMax=0;
				poiseTime=300;
				break;
			case "Supple":
				poiseMax=12.5;
				poiseTime=270;
				break;
			case "Fibrous":
				poiseMax=25;
				poiseTime=243;
				break;
			case "Sturdy":
				poiseMax=50;
				poiseTime=219;
				break;
			case "Rigid":
				poiseMax=100;
				poiseTime=197;
				break;
		
		}
	}
}