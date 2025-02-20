// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function global_init(){

}

// -1 enemy, 1 ally
/*
mirror - Mirror's of the Devil Moon
echo - Moon's Echo
knight - Lunar Knight
ring - Faery's Ring
collector - Compost collector
*/

enum relation {
	ally,
	enemy,
	neutral
}




global.faction_relations = {
    mirror : {
        echo : relation.enemy,
        neutral : relation.neutral,
		player : relation.neutral,
		mindless : relation.enemy
    },
    echo : {
        mirror : relation.enemy,
        neutral : relation.neutral,
		player : relation.neutral,
		mindless : relation.enemy
    },
	neutral : {
		echo : relation.neutral,
		mirror : relation.neutral,
		player : relation.neutral,
		mindless : relation.enemy
	
	},
	mindless :{
		echo : relation.enemy,
        neutral : relation.enemy,
		player : relation.enemy,
		mirror : relation.enemy
	}
}


function generate_identifier() {
    return string(round(xstart)) + "_" + string(round(ystart)) + "_" + string(room);
}

//this function is used for specific relations between NPCs
function special_relation(_id, _relation) constructor {
    identifier = _id;
    relation = _relation;
}

function GetNPCRelation(target_id) {
    for (var i = 0; i < array_length(personal_relations); i++) {
        if target_id.identifier == personal_relations[i].identifier {
            return personal_relations[i].relation;
        }
    }

    var target_faction = target_id.faction;
    if faction == "none" or target_faction == "none" { //decide if you want to use none or neutral
        return relation.neutral;
    }
    
    var relationship_struct = global.faction_relations[$ faction]; //YOU NEED TO TEST THIS ONE!
    return relationship_struct[$ target_faction];
}


////////////////////////////////////old code


 
/*
// Initialize faction relationships
global.faction_relations = ds_map_create();
global.faction_relations[? "mirror"] = {"echo": -1}; // mirrors hate echos
global.faction_relations[? "echo"] = {"mirror": -1}; // echos hate mirrors
global.faction_relations[? "mindless"] = {"player": -1}; // mindless hate everyone
//global.faction_relations[? "player"] = {"mindless": -1, "echo": 0}; // player faction?

*/


/// @desc Gets the relationship between this NPC and another entity.
/// @param target_id
/// @param target_faction
/// @return -1 (hostile), 0 (neutral), 1 (friendly)


/*
//when using this function your object has to have a personal_relations definition
function GetNPCRelation(target_id, target_faction) {
    // Check personal relationships first
    if (ds_map_exists(personal_relations, target_id)) {
        return personal_relations[? target_id];
    }

    // If factionless, default to neutral
    if (faction == "none" || target_faction == "none") {
        return 0;
    }

    // Otherwise, use global faction standings
    if (!ds_map_exists(global.faction_relations, faction)) return 0;
    var relations = global.faction_relations[? faction];
    if (!ds_map_exists(relations, target_faction)) return 0;
    return relations[? target_faction];
}
*/
/*
function GetNPCRelation(target_id, target_faction) {
    // Ensure the map exists before using it
    if (!variable_instance_exists(id, "personal_relations") || personal_relations == noone) {
        return 0; // Default to neutral if the map doesn't exist
    }

    // Check personal relationships first
    if (ds_map_exists(personal_relations, target_id)) {
        return personal_relations[? target_id];
    }

    // If factionless, default to neutral
    if (faction == "none" || target_faction == "none") {
        return 0;
    }

    // Otherwise, use global faction standings
    if (!ds_map_exists(global.faction_relations, faction)) return 0;
    var relations = global.faction_relations[? faction];
    if (!ds_map_exists(relations, target_faction)) return 0;
    return relations[? target_faction];
}

*/
