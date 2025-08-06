shader_type mesh_rasterizer;

uniform mat4 projection;
uniform sampler2D base_texture: source_color;
global uniform vec4 global_color:source_color=vec4(1.0);

void vertex() {
    POSITION = projection * POSITION;
}

void fragment() {
    OUTPUT_COLOR = texture(base_texture, UV) * global_color;
}
