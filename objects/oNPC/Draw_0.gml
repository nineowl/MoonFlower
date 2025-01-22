/// @description Insert description here
// You can write your code in this editor
//draw_self();

//Draw Myself
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha);

if (flashAlpha>0){
	shader_set(shFlash);
	
	draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,flashColor,flashAlpha)
	
	shader_reset();
}


