extends Node2D

var card_scene = preload("res://Objects/card.tscn")
@onready var hand = $Hand

@export var pid: int = 0
var is_turn: bool = false

func _process(_delta) -> void:
	update_hand()

func update_hand():
	
	
	for i in range(hand.get_child_count()):
		hand.get_child(i).position = Vector2(-30 + floor(60 / (hand.get_child_count() + 1)) * i, 0)
