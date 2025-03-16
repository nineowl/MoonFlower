
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 lightPos;    // Light position in screen space
uniform vec4 lightColor;  // Light color and intensity
uniform float lightRadius; // Radius of the light
uniform float intensity;  // New intensity variable



void main() {
	
    // Get fragment position in screen space
    vec2 fragPos = gl_FragCoord.xy;
    
    // Calculate distance from light source
    float dist = distance(fragPos, lightPos);
    
	
	// Simulate dithering using a noise function
	float noise = fract(sin(dot(fragPos, vec2(12.9898, 78.233))) * 43758.5453);
	float dither = (noise - 0.5) * 0.05; // Subtle dithering
	
	
    // Light attenuation (fade effect)
    float attenuation = clamp(1.0 - (dist / lightRadius) + dither, 0.0, 1.0);//clamp(1.0 - (dist / lightRadius), 0.0, 1.0); //
    
	
    // Final color output (pure light)
    vec4 finalColor = vec4(lightColor.rgb * attenuation * intensity, attenuation);
    
    gl_FragColor = finalColor;
}
