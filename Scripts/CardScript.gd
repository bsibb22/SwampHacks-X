extends Node2D

@export var data: CardData
@onready var sprite = $Sprite2D
@onready var main = get_node("../../")
@onready var hovering = false
@onready var my_pid = main.my_pid

func _ready() -> void:
	sprite.texture = main.load_img(-1)
		
# finish coding this after multiplayer is added
func _input(event):
	if hovering and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var top_card = main.pile.back()
		if top_card == null:
			return
		var parent_pid = get_parent().pid
		if parent_pid != my_pid:
			# Card is opponent's card
			if data.card_value == top_card.card_value:
				# deal opponent 2 cards
				main.remove_card(parent_pid, data, true)
				main.deal_card(parent_pid, 2)
			else:
				# deal self 2 cards, deal opponent 1
				main.remove_card(parent_pid, data, false)
				main.deal_card(my_pid, 1)
				main.deal_card(my_pid, 2)
		else:
			# Card is player's card
			if data.card_value != top_card.card_value:
				# deal self 2 cards
				main.remove_card(my_pid, data, false)
				main.deal_card(my_pid, 2)
			else:
				main.remove_card(my_pid, data, true)
	
func _on_area_2d_mouse_entered() -> void:
	hovering = true

func _on_area_2d_mouse_exited() -> void:
	hovering = false
