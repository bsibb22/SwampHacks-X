extends Node2D

@onready var card_scene = preload("res://Objects/card.tscn")
@onready var my_pid = get_parent().my_pid
var num_checked_cards = 0

var selection_state: String = ""

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
		get_child(i).position = Vector2(112.5 - floor(300 / 4) * (i % 4), 100 * floor(i / 4))

func _process(_delta: float) -> void:
	# print(selection_state)
	pass

func _ready() -> void:
	get_parent().update.connect(update_hand)

#Used during the initial phase of the game
func flip_init() -> void:
	num_checked_cards += 1
	print("Player: " + str(my_pid) + ", has checked: " + str(num_checked_cards) + " cards")
	#If the player has checked two unique cards, let the Card Logic script know that it doesn't need to wait
	#on this player
	if num_checked_cards >= 2:
		get_parent().checked_cards[my_pid] = true
		get_parent().card_checked()
