extends Node2D

@export var data: CardData
@onready var sprite = $Sprite2D
@onready var main = get_node("../../")
@onready var hovering = false
@onready var my_pid = main.my_pid

var z: float = 0.15
var c: float = 1.0
func _process(_delta: float) -> void:
	if hovering:
		print(data.card_value)
		
	if hovering:
		z = lerp(z, 0.2, 0.15)
		c = lerp(c, 1.0, 0.2)
	else:
		z = lerp(z, 0.15, 0.2)
		c = lerp(c, 0.75, 0.25)
	modulate = Color(c, c, c, 1.0)
	scale = Vector2(z, z)

func _ready() -> void:
	sprite.texture = main.load_img(-1)
		
# finish coding this after multiplayer is added
func _input(event):
	if hovering and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#main.remove_card(parent_pid, data, true)
		if main.selected_card_to_swap == null:
			if main.pile.size() > 0:
				var top_card: CardData = main.pile.back()
				main.players[my_pid].erase(data)
				main.pile.push_back(data)
				
				# the card belongs to you!
				if data.owner == my_pid:
					# the card is not a match; get dealt 2!!
					if data.card_value != top_card.card_value:
						print("ehhh!! you suck!!!")
						main.deal_card(my_pid, 2)
					else:
						main.update.emit()
		else:
			if data.owner == my_pid:
				var i = main.players[my_pid].find(data)
				main.pile.push_back(data)
				main.players[my_pid][i] = main.selected_card_to_swap
				main.selected_card_to_swap = null
				main.update.emit()
	'''if hovering and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
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
				main.remove_card(my_pid, data, true)'''
	
func _on_area_2d_mouse_entered() -> void:
	hovering = true

func _on_area_2d_mouse_exited() -> void:
	hovering = false
