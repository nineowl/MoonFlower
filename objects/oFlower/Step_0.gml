/// @description Insert description here
// You can write your code in this editor
if (interactEvent){
	array_push(oPlayer.inventory,stats);
	
	interactEvent=false;
	show_debug_message("interacted")
	instance_destroy();
}

damage=0; //because this is a child of oLife. Maybe there's a better way, but this could potentially lead to happy accidents