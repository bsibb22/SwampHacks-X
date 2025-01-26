extends Node2D

signal update

@onready var IMAGE_BANK = []
@onready var CARDBACK = load("res://Sprites/CardSprites/-1.png")
var turn_timer: Timer = Timer.new()
var ending = preload("res://Objects/ending_menu.tscn")
var local_to_online_id = []
var online_to_local_id = {}
var my_online_id = 0
var my_pid = 0
var num_players = 0
var dutch = false
var my_turn = false
#Allows cards to be flipped during the first turn of the game
var flippable_initial = false
var checked_cards = {}
var turns_till_end = 9223372036854775807

var selected_card_to_swap = null

func load_img(id: int) -> CompressedTexture2D:
	if(id == -1):
		return CARDBACK
	else:
		return IMAGE_BANK[id]

func shuffle_deck() -> void:
	# Save the most recently played card
	var temp = pile.pop_back()

	# Randomly add cards from the discard pile to the deck
	pile.append(garbage)
	garbage.clear()
	while pile.size() > 0:
		var c = pile.pick_random()
		if (c == temp):
			continue
		c.update_owner(8)
		deck.push_back(c)
	
	pile.push_back(temp)


func deal_card(pid, num_cards) -> void:
	for i in range(num_cards):
		players[pid].push_back(deck.pop_back())
		if(deck.size() < 1):
			shuffle_deck()
	update.emit()


# for these 2 functions it is assumed the hands will update later
func remove_card(pid, card, valid) -> void:
	players[pid].remove(card)
	if valid:
		# add card to pile if valid play
		pile.push_back(card)
		card.update_owner(9)
	else:
		# add card to garbage if not valid play
		garbage.push_back(card)
		card.update_owner(10)
	update.emit()
			
	

func swap_card(pid_1, pid_2, card_1, card_2) -> void:
	players[pid_1][players[pid_1].find(card_1)] = card_2
	players[pid_2][players[pid_2].find(card_2)] = card_1
	card_2.update_owner(pid_1)
	card_1.update_owner(pid_2)
	update.emit()

# TURN LOGIC
var turn_counter: int = 0
var turn_seconds: int = 1

func start_turns() -> void:
	add_child(turn_timer)
	turn_timer.timeout.connect(change_turns)
	turn_timer.wait_time = turn_seconds
	turn_timer.autostart = true
	turn_timer.start()

func change_turns() -> void:
	# start_turns()
	print("turns changed!")
	turn_counter += 1
	if dutch:
		turns_till_end -= 1
	if turn_counter >= num_players:
		turn_counter = 0
	if turn_counter == my_pid:
		my_turn = true
		if !dutch:
			$"Control/Dutch Button".visible = true
	else:
		my_turn = false
		$"Control/Dutch Button".visible = false
		
	if players[turn_counter].size() <= 0:
		change_turns()

# ---- #

var deck = [] # stack
var players = [] # 2d player array
var pile = [] # face up pile of cards you can choose from
var garbage = [] # cards that have been lost to time

func _ready() -> void:
	start_turns()
	$"Control/Dutch Button".visible = false
	# match local and online ids
	var local_id = 0
	my_online_id = multiplayer.get_unique_id()
	for i in GameManager.Players:
		var online_id = GameManager.Players[i].id
		local_to_online_id.push_back(online_id)
		online_to_local_id[online_id] = local_id
		if online_id == my_online_id:
			my_pid = local_id
		print("pid " + str(local_id) + " matched to online id " + str(GameManager.Players[i].id))
		local_id += 1
		
	num_players = local_id
	print(num_players)
		
	# Create the pile of cards
	for i in range(54):
		# make new card with id i and owner pile
		var c: CardData = CardData.new(i) # change to i after card images are added
		IMAGE_BANK.push_back(load("res://Sprites/CardSprites/" + str(i) + ".png"))
		deck.push_back(c)

	# Shuffle the deck
	deck.shuffle()
	
	# Deal the cards
	for i in range(num_players):
		players.push_back([])
		deal_card(i, 4)
		print("player " + str(i) + "'s cards: ")
		for j in players[i]:
			print(j.card_value)
			
	print(deck.back().card_value)
	pile.push_back(deck.pop_back())
	update.emit()
		
	#Let players check their cards
	flippable_initial = true
	#Dictionary tracks which players have checked their cards
	for i in online_to_local_id:
		checked_cards[i] = false
	var all_cards_checked = false
	#Block until all players have checked their cards
	while !all_cards_checked:
		var temp = true
		for i in checked_cards:
			if !checked_cards[i]:
				temp = false
		all_cards_checked = temp
	
	
	start_turns()


func _process(_delta) -> void:
	# check if any players have run out of cards
	for i in players:
		if i.size() <= 0:
			_on_dutch_button_button_down()
	
	if turns_till_end == 0:
		print("Game Over")
		turn_timer.stop()
		var winner_pid = 20
		var winner_score = 9223372036854775807
		for i in range(players.size()):
			var score = 0
			for j in players[i]:
				score += j.card_value
			print("player " + str(i) + "'s score is " + str(score))
			if score < winner_score:
				winner_pid = i
				winner_score = score
		if my_pid == winner_pid:
			print("winner winner chicken dinner")
		else:
			print("fuck you")
		turns_till_end -= 1
		var ending_menu = ending.instantiate()
		add_child(ending_menu)



#This is broken
func _on_dutch_button_button_down() -> void:
	print("Dutch button pressed")
	turns_till_end = num_players - 1
	print("Turns till end: " + str(turns_till_end))
	dutch = true
	change_turns()
