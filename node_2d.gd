@tool
extends Node2D

@export var mesh: Mesh
var tex := RID()
var rasterizer := RID()
var tex_size := 64


func _draw() -> void:
    RenderingServer.canvas_item_add_texture_rect(get_canvas_item(), Rect2(0, 0, tex_size, tex_size), tex)

var r := 0.0

func _physics_process(delta: float) -> void:
    if tex.is_valid():
        RenderingServer.free_rid(tex)
    if rasterizer.is_valid():
        RenderingServer.free_rid(rasterizer)

    tex_size += delta * 200
    if tex_size > 512: tex_size = 64;

    rasterizer = RenderingServer.mesh_rasterizer_create(tex_size, tex_size, false)
    if mesh != null and mesh.get_rid().is_valid():
        RenderingServer.mesh_rasterizer_set_mesh(rasterizer, mesh.get_rid(), 0)
    tex = RenderingServer.texture_rd_create(RenderingServer.mesh_rasterizer_get_rd_texture(rasterizer))

    r += delta / 8
    if r > 1.0: r = 0;
    RenderingServer.mesh_rasterizer_set_bg_color(rasterizer, Color(r, 0, 0))
    queue_redraw()

func _exit_tree():
    if tex.is_valid():
        RenderingServer.free_rid(tex)
    if rasterizer.is_valid():
        RenderingServer.free_rid(rasterizer)
