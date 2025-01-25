extends Node2D

func change_sprite():
	if get_parent().pile.size() == 0:
		$Sprite2D.texture = CompressedTexture2D.new()
	else:
		$Sprite2D.texture = get_parent().load_img(get_parent().pile.back().id)

func _ready() -> void:
	change_sprite()
	get_parent().update.connect(change_sprite)
