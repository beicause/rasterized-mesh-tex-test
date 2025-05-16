shader_type rasterize_mesh;

uniform mat4 projection;
uniform sampler2D base_texture: source_color;

void vertex() {
    VERTEX = projection * VERTEX;
	COLOR.rg=UV;
}

//void fragment() {
    //texture(base_texture, UV);
//}
