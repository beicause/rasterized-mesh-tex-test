shader_type mesh_rasterizer;
render_mode cull_back;

uniform mat4 projection;
uniform sampler2D base_texture: source_color;

void vertex() {
    VERTEX = projection * VERTEX;
	COLOR.rg=UV*1.0;
}

//void fragment() {
    //texture(base_texture, UV);
//}
