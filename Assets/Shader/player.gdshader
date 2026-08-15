shader_type canvas_item;

// 1. Pick the exact color of your windows in the Inspector
uniform vec4 window_color : source_color = vec4(0.56, 0.76, 0.89, 1.0); 
// 2. Tolerance handles slight color variations (0.05 is usually perfect)
uniform float tolerance = 0.05; 

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    
    // Check how close the current pixel color is to your window color
    float color_match = step(distance(tex.rgb, window_color.rgb), tolerance);
    
    // Create the moving diagonal shine line
    float shine = step(0.98, sin(UV.x + UV.y + TIME * 3.0));
    
    // Add the shine ONLY if color_match equals 1 (a perfect match)
    vec3 final_color = tex.rgb + (vec3(shine * 0.5) * color_match);
    
    COLOR = vec4(final_color, tex.a);
}
