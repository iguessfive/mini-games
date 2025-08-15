shader_type canvas_item;

uniform float corner_fraction : hint_range(0.0, 1.0) = 0.0; // fraction of min(width, height)
uniform vec4 rect_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float inner_padding : hint_range(0.0, 0.5) = 0.0; // inner padding in pixels (0 = no padding)

void fragment() {
    // Get sprite size in pixels
    vec2 half_size = vec2(textureSize(TEXTURE, 0)) * 0.5;

    // Calculate corner radius as fraction of smaller dimension
    float corner_radius = corner_fraction * min(half_size.x, half_size.y);

    // Local coords centered at 0
    vec2 local_pos = (UV - 0.5) * vec2(textureSize(TEXTURE, 0));

    // Distance from outer rounded rectangle edges
    vec2 outer_dist = abs(local_pos) - (half_size - vec2(corner_radius));
    float outside_outer = length(max(outer_dist, 0.0));

    // Discard pixels completely outside the outer shape
    if (outside_outer > corner_radius) {
        discard;
    }

    if (inner_padding > 0.0) {
        float applied_inner_padding = 0.5 - inner_padding;
        // Calculate inner rect size (with padding)
        float min_half = min(half_size.x, half_size.y);
        float inner_corner_radius = max(corner_radius - applied_inner_padding, 0.0);
        vec2 inner_half_size = half_size - vec2(applied_inner_padding);

        // Distance from inner rounded rectangle edges
        vec2 inner_dist = abs(local_pos) - (inner_half_size - vec2(inner_corner_radius));
        float inside_inner = length(max(inner_dist, 0.0));

        // Discard pixels inside the inner shape (doughnut hole)
        if (inside_inner < inner_corner_radius) {
            discard;
        }

    }

    COLOR = rect_color;
}