extends Node2D
var hovering = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event) -> void:
	if hovering and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_parent().deal_card(global.pid, 1)

func _on_area_2d_mouse_entered() -> void:
	hovering = true

func _on_area_2d_mouse_exited() -> void:
	hovering = false
