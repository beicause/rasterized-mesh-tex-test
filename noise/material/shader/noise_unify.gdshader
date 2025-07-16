shader_type mesh_rasterizer;

#include "uid://c8j7ucouq0uf8"

uniform vec3 size = vec3(1024.0);
uniform vec2 offset = vec2(0.0);

uniform int noise_seed = 1337;
uniform float noise_frequency = 0.01;

uniform bool terrace_enabled = false;
uniform float terrace = 4.0;

uniform bool remap_enabled = false;
uniform sampler2D remap : source_color, repeat_disable;

uniform int noise_noise_type : hint_enum(
									   "OPENSIMPLEX2",
									   "OPENSIMPLEX2S",
									   "CELLULAR",
									   "PERLIN",
									   "VALUE_CUBIC",
									   "VALUE") = FNL_NOISE_OPENSIMPLEX2;
uniform int noise_rotation_type_3d : hint_enum(
											 "NONE",
											 "IMPROVE_XY_PLANES",
											 "IMPROVE_XZ_PLANES") = FNL_ROTATION_NONE;
uniform int noise_fractal_type : hint_enum(
										 "NONE",
										 "FBM",
										 "RIDGED",
										 "PINGPONG",
										 "DOMAIN_WARP_PROGRESSIVE",
										 "DOMAIN_WARP_INDEPENDENT") = FNL_FRACTAL_NONE;
uniform int noise_octaves = 3;
uniform float noise_lacunarity = 2.0;
uniform float noise_gain = 0.5;
uniform float noise_weighted_strength = 0.0;
uniform float noise_ping_pong_strength = 2.0;
uniform int noise_cellular_distance_func : hint_enum(
												   "DISTANCE_EUCLIDEAN",
												   "DISTANCE_EUCLIDEANSQ",
												   "DISTANCE_MANHATTAN",
												   "DISTANCE_HYBRID") = FNL_CELLULAR_DISTANCE_EUCLIDEANSQ;
uniform int noise_cellular_return_type : hint_enum(
												 "RETURN_TYPE_CELLVALUE",
												 "RETURN_TYPE_DISTANCE",
												 "RETURN_TYPE_DISTANCE2",
												 "RETURN_TYPE_DISTANCE2ADD",
												 "RETURN_TYPE_DISTANCE2SUB",
												 "RETURN_TYPE_DISTANCE2MUL",
												 "RETURN_TYPE_DISTANCE2DIV") = FNL_CELLULAR_RETURN_TYPE_DISTANCE;
uniform float noise_cellular_jitter_mod = 1.0;
uniform int noise_domain_warp_type : hint_enum(
											 "WARP_OPENSIMPLEX2",
											 "WARP_OPENSIMPLEX2_REDUCED",
											 "WARP_BASICGRID") = FNL_DOMAIN_WARP_OPENSIMPLEX2;
uniform float noise_domain_warp_amp = 1.0;

uniform bool is_3d = false;
uniform float depth : hint_range(0.0, 1.0, 0.0001) = 0.0;

void vertex() {
	vec2 base_arr[3] = vec2[](vec2(-1.0, -1.0), vec2(3.0, -1.0), vec2(-1.0, 3.0));
	POSITION = vec4(base_arr[VERTEX_ID], 0.0, 1.0);
	UV = clamp(POSITION.xy, vec2(0.0, 0.0), vec2(1.0, 1.0)) * 2.0; // saturate(x) * 2.0
}

void fragment() {
	vec2 uv = UV / 2.0;
	fnl_state state = fnlCreateState(noise_seed);
	state.frequency = noise_frequency; //0.01;
	state.noise_type = noise_noise_type; //FNL_NOISE_OPENSIMPLEX2;
	state.rotation_type_3d = noise_rotation_type_3d; //FNL_ROTATION_NONE;
	state.fractal_type = noise_fractal_type; //FNL_FRACTAL_NONE;
	state.octaves = noise_octaves; //3;
	state.lacunarity = noise_lacunarity; //2.0;
	state.gain = noise_gain; //0.5;
	state.weighted_strength = noise_weighted_strength; //0.0;
	state.ping_pong_strength = noise_ping_pong_strength; //2.0;
	state.cellular_distance_func = noise_cellular_distance_func; //FNL_CELLULAR_DISTANCE_EUCLIDEANSQ;
	state.cellular_return_type = noise_cellular_return_type; //FNL_CELLULAR_RETURN_TYPE_DISTANCE;
	state.cellular_jitter_mod = noise_cellular_jitter_mod; //1.0;
	state.domain_warp_type = noise_domain_warp_type; //FNL_NOISE_OPENSIMPLEX2;
	state.domain_warp_amp = noise_domain_warp_amp; //1.0;

	FNLfloat val;

	if (!is_3d) {
		val = fnlGetNoise2D(state, uv.x * size.x + offset.x, uv.y * size.y + offset.y) / 2.0 + 0.5;
	} else {
		val = fnlGetNoise3D(state, uv.x * size.x + offset.x, uv.y * size.y + offset.y, depth * size.z) / 2.0 + 0.5;
	}

	if (remap_enabled) {
		val = texture(remap, vec2(val, 0.0)).r;
	}

	if (terrace_enabled) {
		val = round(val * terrace) / terrace;
	}

	COLOR = vec4(val, 0.0, 0.0, 1.0);
}
