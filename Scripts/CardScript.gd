extends Sprite2D

@export_range(0, 13) var card_value: int = 1
@export_enum("HEART", "CLUB", "DIAMOND", "SPADE") var suit: String = "HEART"
var known: bool = false

@onready var area = $Area2D
@onready var sprite = $Sprite2D

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print_rich()
	pass # Replace with function body.
