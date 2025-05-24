extends Sprite2D

func _ready() -> void:
    var mesh_tex: RasterizedMeshTexture = texture
    mesh_tex.texture_format = RenderingDevice.DATA_FORMAT_R16_SFLOAT
