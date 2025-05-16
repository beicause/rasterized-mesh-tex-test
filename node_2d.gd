@tool
extends Node2D

@export var mesh: Mesh
var tex := RID()
var rasterizer := RID()
var tex_size := 64


func _draw() -> void:
	RenderingServer.canvas_item_add_texture_rect(get_canvas_item(), Rect2(0, 0, tex_size, tex_size), tex)

var r := 0.0
var increase := 1

func _physics_process(delta: float) -> void:
	if tex.is_valid():
		RenderingServer.free_rid(tex)
	if rasterizer.is_valid():
		RenderingServer.free_rid(rasterizer)

	tex_size += increase * delta * 100.0
	if tex_size > 128: increase = -1;
	if tex_size < 64: increase = 1
	
	rasterizer = RenderingServer.mesh_rasterizer_create(tex_size, tex_size, RenderingServer.RASTERIZED_TEXTURE_FORMAT_RGBAH)
	if mesh != null and mesh.get_rid().is_valid():
		RenderingServer.mesh_rasterizer_set_mesh(rasterizer, mesh.get_rid(), 0)
	tex = RenderingServer.texture_rd_create(RenderingServer.mesh_rasterizer_get_rd_texture(rasterizer))

	r += delta / 4
	if r > 1.0: r = 0;
	RenderingServer.mesh_rasterizer_set_bg_color(rasterizer, Color(r, 0, 0))

	RenderingServer.mesh_rasterizer_draw(rasterizer)
	queue_redraw()

func _exit_tree():
	if tex.is_valid():
		RenderingServer.free_rid(tex)
	if rasterizer.is_valid():
		RenderingServer.free_rid(rasterizer)
