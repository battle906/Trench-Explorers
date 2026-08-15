shader_type canvas_item;

void vertex() {
    // Bends the sprite left and right based on time and vertical position
    // Increase 10.0 for speed, increase 20.0 for a stronger wave curve
    VERTEX.x += sin(TIME * 3.0 + VERTEX.y) * 10.0 * (1.0 - UV.y);
}

