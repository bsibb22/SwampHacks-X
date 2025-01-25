extends Node2D

@export var data: CardData
@onready var sprite = $Sprite2D

func _ready() -> void:
	if(data.id <= 0):
		sprite.texture = get_node("../../").load_img(data.id)
