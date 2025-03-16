
// Check if surface exists, recreate if needed
if (!surface_exists(lightSurface)) {
    lightSurface = surface_create(room_width, room_height);
}

// Set target to surface
surface_set_target(lightSurface);
draw_clear_alpha(c_white, 0); // Clear surface with transparency

shader_set(shGlow);

var uniform_lightPos = shader_get_uniform(shGlow, "lightPos");
var uniform_lightColor = shader_get_uniform(shGlow, "lightColor");
var uniform_lightRadius = shader_get_uniform(shGlow, "lightRadius");
var uniform_intensity = shader_get_uniform(shGlow, "intensity");

// Send uniform values
shader_set_uniform_f(uniform_lightPos, x, y);
shader_set_uniform_f(uniform_lightColor, 
                     color_get_red(lightColor) / 255.0, 
                     color_get_green(lightColor) / 255.0, 
                     color_get_blue(lightColor) / 255.0, 1.0);
shader_set_uniform_f(uniform_lightRadius, lightRadius);
shader_set_uniform_f(uniform_intensity, intensity); // Adjust this value to increase brightness
var offsetY = -8; // Move the light up by 10 pixels
shader_set_uniform_f(uniform_lightPos, x, y + offsetY);



// Draw a full-screen rectangle so the shader covers everything
draw_rectangle(0, 0, room_width, room_height, false);

shader_reset();
surface_reset_target();

// Draw the lighting surface on top of the game scene
draw_surface(lightSurface, 0, 0);

draw_self();

