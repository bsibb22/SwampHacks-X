extends Node2D

@export var data: CardData
@onready var sprite = $Sprite2D
@onready var main = get_node("../../")
@onready var hovering = false
@onready var my_pid = main.my_pid
var flipped = false
#Used to make sure that the player does not flip the same card twice during the beginning of the game
var previously_flipped = false

func _ready() -> void:
	sprite.texture = main.load_img(-1)
		
# finish coding this after multiplayer is added
func _input(event):
	if hovering and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var top_card = main.pile.back()
		if top_card == null:
			return
		var parent_pid = get_parent().my_pid
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
	#Handles Flipping
	elif hovering and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		var parent_pid = get_parent().my_pid
		#Will be used for face cards
		if parent_pid != my_pid:
			return
		#Only works at the beginning of the game
		elif main.flippable_initial and !previously_flipped:
			flip()
			previously_flipped = true
			var timer : Timer = Timer.new()
			timer.timeout.connect(flip)
			timer.wait_time = 3
			timer.one_shot = true
			timer.autostart = true
			timer.start()
			add_child(timer)
			get_parent()	.flip_init()
			
func _on_area_2d_mouse_entered() -> void:
	hovering = true

func _on_area_2d_mouse_exited() -> void:
	hovering = false
	
#Flips the card by changing the sprite
func flip() -> void:
	print("Data: " + str(data.id))
	if !flipped:
		sprite.texture = main.load_img(data.id)
		flipped = true
	else:
		sprite.texture = main.load_img(-1)
		flipped = false
	
	pass
