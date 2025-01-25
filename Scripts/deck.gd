extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
	# if(player.is_turn):
		get_parent().deal_card(0, 1)
		print("works")
