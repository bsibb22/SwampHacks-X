extends Node2D

var card_scene = preload("res://Objects/card.tscn")

@export var pid: int = 0
var is_turn: bool = false

func update_hand():
	print(get_parent().players)
	while get_child_count() > 0:
		get_child(0).queue_free()
	for i in range(get_parent().players[global.pid].size()):
		var c = get_parent().players[global.pid][i]
		c.owner = global.pid
		var cs = card_scene.instantiate()
		cs.data = c
		cs.rotation = deg_to_rad(randf_range(-10, 10))
		add_child(cs)

	for i in range(get_child_count()):
		get_child(i).position = Vector2(-180 + floor(360 / (get_child_count())) * i, 0)
		
		
func _ready():
	connect("update", update_hand())
