extends Node2D

@onready var card_scene = preload("res://Objects/card.tscn")
@onready var my_pid = get_parent().my_pid

func update_hand():
	for c in get_children():
		c.free()
	
	for i in range(get_parent().players[my_pid].size()):
		var c = get_parent().players[my_pid][i]
		c.owner = my_pid
		var cs = card_scene.instantiate()
		cs.data = c
		add_child(cs)

	for i in range(get_child_count()):
		get_child(i).position = Vector2(-180 + floor(360 / (get_child_count())) * i, 0)
		
func _ready() -> void:
	get_parent().update.connect(update_hand)
