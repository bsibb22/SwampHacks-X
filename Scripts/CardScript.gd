extends Node2D

@export var data: CardData
@onready var sprite = $Sprite2D

func _ready() -> void:
	sprite.texture = card_logic.load_img(data.card_value)
