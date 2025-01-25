extends Node2D

@export var data: CardData

@onready var area = $Area2D
@onready var sprite = $Sprite2D

func _ready() -> void:
	sprite.texture = global.load_img("card_" + str(data.card_value))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
