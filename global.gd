extends Node

@onready var IMAGE_BANK = {
	"HEART_A": load("res://Sprites/ace.png"),
	"CARDBACK": load("res://Sprites/cardback.png")
}

func load_img(img_key: String) -> Sprite2D:
	if IMAGE_BANK[img_key]:
		return IMAGE_BANK[img_key]
	else:
		print("ERROR: no image found with key %s!" % img_key)
		return Sprite2D.new()

var value_bank = ['$', 'A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
func _shuffle(arr = []):
	pass
	
func _ready() -> void:
	
