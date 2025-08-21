shader_type canvas_item;

uniform int colorblind_type : hint_range(0, 2) = 0; // 0: Protanopia, 1: Deuteranopia, 2: Tritanopia

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    vec3 rgb = color.rgb;

    if (colorblind_type == 0) { // Protanopia
        rgb = vec3(
            0.56667 * rgb.r + 0.43333 * rgb.g + 0.0 * rgb.b,
            0.55833 * rgb.r + 0.44167 * rgb.g + 0.0 * rgb.b,
            0.0 * rgb.r + 0.24167 * rgb.g + 0.75833 * rgb.b
        );
    } else if (colorblind_type == 1) { // Deuteranopia
        rgb = vec3(
            0.625 * rgb.r + 0.375 * rgb.g + 0.0 * rgb.b,
            0.7 * rgb.r + 0.3 * rgb.g + 0.0 * rgb.b,
            0.0 * rgb.r + 0.3 * rgb.g + 0.7 * rgb.b
        );
    } else if (colorblind_type == 2) { // Tritanopia
        rgb = vec3(
            0.95 * rgb.r + 0.05 * rgb.g + 0.0 * rgb.b,
            0.0 * rgb.r + 0.43333 * rgb.g + 0.56667 * rgb.b,
            0.0 * rgb.r + 0.475 * rgb.g + 0.525 * rgb.b
        );
    }

    COLOR = vec4(rgb, color.a);
}
