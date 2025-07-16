shader_type mesh_rasterizer;

uniform mat4 projection;
uniform sampler2D base_texture;

void vertex() {
    POSITION = projection * POSITION;
}

void fragment() {
    COLOR = texture(base_texture, UV);
}
