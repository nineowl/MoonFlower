// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function flower(){

}

//as you implement the next properties you must expand the constructor
function Flower(_petals, _type, _leaves, _thorns, _poisonous, _stemType) constructor {
    petals = _petals;          // Number of hits it can take
    type = _type;				//Determines appearance/effects
    leaves = _leaves;          // (Future: stamina if implemented)
    thorns = _thorns;          // True/false: has thorns?
    poisonous = _poisonous;    // True/false: poisonous effect?
    stemType = _stemType;      // Different stem types for variation

    lifespan = 100;            // How long it lasts (if needed)
    age = 0;                   // Track its age (if needed)

    // Future properties
    glows = false;             // Does it glow in the dark?
    sweetNectar = false;       // Attracts creatures?
}