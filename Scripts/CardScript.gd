extends Node2D

@export var data: CardData
@onready var sprite = $Sprite2D
@onready var main = get_node("../../")
@onready var hovering = false
@onready var my_pid = main.my_pid

var previously_flipped = false
var flipped = false

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
	if hovering and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !main.flippable_initial:
		#main.remove_card(parent_pid, data, true)
		if main.selected_card_to_swap == null:
			if main.pile.size() > 0:
				var top_card: CardData = main.pile.back()
				main.players[my_pid].erase(data)
				main.pile.push_back(data)
				
				if data.card_value == 10:
					return
				#If a Jack is played
				elif data.card_value == 11:
					main.jacking_off()
				
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
				main.remove_card(my_pid, data, true)'''
	#Handles Flipping
	if hovering and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		var parent_pid = get_parent().my_pid
		#Will be used for face cards
		if parent_pid != my_pid:
			#Flip opponents card when jack is flipped
			if main.jacking_it:
				meta_flip()
				main.jacking_off()
		#Only works at the beginning of the game
		elif main.flippable_initial and !previously_flipped:
			meta_flip()
			get_parent()	.flip_init()
		
			
func _on_area_2d_mouse_entered() -> void:
	hovering = true

func _on_area_2d_mouse_exited() -> void:
	hovering = false
	
func meta_flip() -> void:
	flip()
	previously_flipped = true
	var timer : Timer = Timer.new()
	timer.timeout.connect(flip)
	timer.wait_time = 3
	timer.one_shot = true
	timer.autostart = true
	timer.start()
	add_child(timer)
	
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
