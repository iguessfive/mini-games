shader_type canvas_item;

uniform float corner_fraction : hint_range(0.0, 1.0) = 0.0; // fraction of min(width, height)
uniform vec4 rect_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float inner_padding : hint_range(0.0, 100.0) = 0.0; // inner padding in pixels (0 = no padding)

void fragment() {
    // Get sprite size in pixels
    vec2 half_size = vec2(textureSize(TEXTURE, 0)) * 0.5;

    // Calculate corner radius as fraction of smaller dimension
    float corner_radius = corner_fraction * min(half_size.x, half_size.y);

    // Local coords centered at 0
    vec2 local_pos = (UV - 0.5) * vec2(textureSize(TEXTURE, 0));

    // Distance from rounded rectangle edges
    vec2 dist = abs(local_pos) - (half_size - vec2(corner_radius));
    float outside = length(max(dist, 0.0));

    if (outside > corner_radius) {
        discard;
    }

    COLOR = rect_color;
}