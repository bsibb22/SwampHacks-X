extends Node2D

var card_scene = preload("res://Objects/card.tscn")

@export var pid: int = 0
var is_turn: bool = false

func get_score() -> int:
	var score: int = 0
	for c in get_children():
		score += c.data.card_value
	return score

func update_hand():
	for c in get_children():
		c.free()
	
	for i in range(get_parent().players[global.pid].size()):
		var c = get_parent().players[global.pid][i]
		c.owner = global.pid
		var cs = card_scene.instantiate()
		cs.data = c
		cs.rotation = deg_to_rad(randf_range(-10, 10))
		add_child(cs)

	for i in range(get_child_count()):
		get_child(i).position = Vector2(-180 + floor(360 / (get_child_count())) * i, 0)
		
func _ready() -> void:
	get_parent().update.connect(update_hand)
