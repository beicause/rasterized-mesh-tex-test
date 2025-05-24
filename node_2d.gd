extends Node2D

@export var mesh: Mesh
var tex := RID()
var rasterizer := RID()
var tex_size := 128
@export var mt := ShaderMaterial.new()

func _draw() -> void:
    if tex.is_valid():
        RenderingServer.free_rid(tex)
    if rasterizer.is_valid():
        RenderingServer.free_rid(rasterizer)
	
    if mesh != null and mesh.get_rid().is_valid():
        rasterizer = RenderingServer.mesh_rasterizer_create(mesh.get_rid(), 0)

    tex = RenderingServer.texture_drawable_ctreate(tex_size, tex_size, RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM)

    var attachment := RasterizerBlendState.new()
    attachment.enable_blend = true
    attachment.alpha_blend_op = RenderingDevice.BLEND_OP_ADD
    attachment.color_blend_op = RenderingDevice.BLEND_OP_ADD
    attachment.src_color_blend_factor = RenderingDevice.BLEND_FACTOR_SRC_ALPHA
    attachment.dst_color_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
    attachment.src_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_SRC_ALPHA
    attachment.dst_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE

    RenderingServer.mesh_rasterizer_draw(rasterizer, mt.get_rid(), tex, null, Color(.5, .5, .5))
    var p := Projection.IDENTITY
    p.w[3] = 2
    mt.set_shader_parameter("projection", p)
    RenderingServer.mesh_rasterizer_draw(rasterizer, mt.get_rid(), tex, attachment, Color(0, 0, 0))

    RenderingServer.canvas_item_add_texture_rect(get_canvas_item(), Rect2(0, 0, tex_size, tex_size), tex)

func _exit_tree():
    if tex.is_valid():
        RenderingServer.free_rid(tex)
    if rasterizer.is_valid():
        RenderingServer.free_rid(rasterizer)
