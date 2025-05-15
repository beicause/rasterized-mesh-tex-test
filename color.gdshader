shader_type rasterize_mesh;

uniform vec4 color:source_color;

void fragment() {
    COLOR =color;
}
