shader_type mesh_rasterizer;

uniform mat4 projection;
uniform sampler2D base_texture:source_color;

void vertex() {
    VERTEX = projection * VERTEX;
}

void fragment() {
    COLOR=texture(base_texture, UV);
}