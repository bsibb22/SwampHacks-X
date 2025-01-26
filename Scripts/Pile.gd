extends Node2D

var hovering = false
var can_play = false

func change_state():
	if get_parent().pile.size() == 0:
		$Sprite2D.texture = CompressedTexture2D.new()
		can_play = false
	else:
		$Sprite2D.texture = get_parent().load_img(get_parent().pile.back().id)
		can_play = true

func _ready() -> void:
	change_state()
	get_parent().update.connect(change_state)
	
func _input(event) -> void:
	if can_play and get_parent().my_turn and hovering and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_parent().pull_from_pile(get_parent().my_pid)

func _on_area_2d_mouse_entered() -> void:
	hovering = true

func _on_area_2d_mouse_exited() -> void:
	hovering = false
