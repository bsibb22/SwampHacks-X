extends Sprite2D

@export var data: Resource

@onready var area = $Area2D
@onready var sprite = $Sprite2D

func _ready() -> void:
  sprite.texture = global.load_img(data.suit + "_" + data.card_value)
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
  print_rich(data.card_value + ", " + data.card_suit)
  pass # Replace with function body.
