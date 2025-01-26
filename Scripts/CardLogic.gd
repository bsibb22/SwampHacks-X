extends Node2D

signal update
signal _flippity
signal send_data

@onready var IMAGE_BANK = []
@onready var CARDBACK = load("res://Sprites/CardSprites/-1.png")
var turn_timer
var timer_paused
var ending = preload("res://Objects/ending_menu.tscn")
var player = preload("res://Objects/player.tscn")
var local_to_online_id = []
var online_to_local_id = {}
var my_online_id = 0
var my_pid = 0
var num_players = 0
var jacking_it = false
var tenten = false
var dutch = false
var i_cant_take_it_anymore = true
var my_turn = false
#Allows cards to be flipped during the first turn of the game
var flippable_initial = true
var checked_cards = {}
var turns_till_end = 9223372036854775807
var game_state = false
var all_cards = []

var selected_card_to_swap = null

func load_img(id: int) -> CompressedTexture2D:
	if(id == -1):
		return CARDBACK
	else:
		return load("res://Sprites/CardSprites/" + str(id) + ".png")

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
var turn_seconds: int = 15

func change_turns() -> void:
	turn_counter += 1
	if dutch:
		turns_till_end -= 1
	if turn_counter >= num_players:
		turn_counter = 0
	if turn_counter == my_pid:
		my_turn = true
		if !dutch:
			$"Dutch Button".visible = true
	else:
		my_turn = false
		$"Dutch Button".visible = false
	
	if my_pid == 0:
		turn_timer = 15
	
	if players[turn_counter].size() <= 0:
		change_turns()

# ---- #

var deck = [] # stack
var players = [] # 2d player array
var pile = [] # face up pile of cards you can choose from
var garbage = [] # cards that have been lost to time

func _ready() -> void:
	send_data.connect(send)
	$"Dutch Button".visible = false
	
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
	
	# var player_angle = (my_pid * (2.0 * PI / float(num_players)))
	for i in range(num_players):
		players.push_back([])
		var player_angle = float(abs(i - my_pid)) * (2.0 * PI / float(num_players))

		var p = player.instantiate()
		p.position = Vector2(cos(player_angle) * float(300), sin(player_angle) * float(300))
		p.rotation = (player_angle + 0.5 * PI)
		add_child(p)
		
	print(str(num_players) + " player game")
	
	# Create the pile of cards
	for i in range(54):
		# make new card with id i and owner pile
		var c: CardData = CardData.new(i) # change to i after card images are added
		IMAGE_BANK.push_back(load("res://Sprites/CardSprites/" + str(i) + ".png"))
		deck.push_back(c)
		all_cards.push_back(c)
	
	if my_pid == 0:
		# Shuffle the deck
		deck.shuffle()
		
		# Deal the cards
		for i in range(num_players):
			deal_card(i, 4)
			# print("player " + str(i) + "'s cards: ")
			for j in players[i]:
				print(j.card_value)
				
		# print(deck.back().card_value)
		pile.push_back(deck.pop_back())
		
	send_data.emit()
	update.emit()
		
	#Let players check their cards
	flippable_initial = true
	#Dictionary tracks which players have checked their cards
	for i in range(num_players):
		checked_cards[i] = false
	print("Checked Cards Initialized")
	
func card_checked() -> void:
	print("Card checked")
	var temp = true
	for i in checked_cards:
		print("Player: " + str(i) + ", Checked: " + str(checked_cards[i]))
		if !checked_cards[i]:
			temp = false
			
	if temp:
		flippable_initial = false

#Called when a 10 is played
func tennessee() -> void:
	if !tenten:
		tenten = true
		timer_paused = true
	else:
		tenten = false
		timer_paused = false
		change_turns()

#Called when a jack is played
func jacking_off() -> void:
	if !jacking_it:
		jacking_it = true
		timer_paused = true
	else:
		jacking_it = false
		timer_paused = false
		change_turns()
		

func _process(_delta) -> void:
	# check if any players have run out of cards
	if game_state:
		if !timer_paused:
			turn_timer -= _delta
		for i in players:
			if i.size() <= 0:
				_on_dutch_button_button_down()
		
		if turns_till_end <= 0 and i_cant_take_it_anymore:
			end_this_shit()

func end_this_shit() -> void:
	_flippity.emit()
	i_cant_take_it_anymore = false
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
		print("you lose")
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
	
	
@rpc
func receive(data: Array):
	print("Data recieved: ", data)
	
	var encoded_deck = data[0]
	var encoded_players = data[1]
	var encoded_pile = data[2]
	var encoded_garbage = data[3]
	dutch = data[4]
	turn_timer = data[5]
	turn_counter = data[6]
	game_state = data[7]
	timer_paused = data[8]
	checked_cards = data[9]
	
	# decode deck
	var temp_deck = []
	for i in encoded_deck:
		var c: CardData = all_cards[i]
		temp_deck.push_back(c)
	deck = temp_deck
	
	# decode pile
	var temp_pile = []
	for i in encoded_pile:
		var c: CardData = all_cards[i]
		temp_pile.push_back(c)
	pile = temp_pile
	
	# decode garbage
	var temp_garbage = []
	for i in encoded_garbage:
		var c: CardData = all_cards[i]
		temp_garbage.push_back(c)
	garbage = temp_garbage
	
	# decode players
	var temp_players = []
	for i in range(num_players):
		temp_players.push_back([])
	for i in range(num_players):
		for j in encoded_players[i]:
			var c: CardData = all_cards[j]
			temp_players[i].push_back(c)
	players = temp_players
	
	print("players array: ", players) 
	print("temp players array: ", temp_players) 

	update.emit()
	
	print("my_pid: " + str(my_pid))
	for i in range(0, num_players):
		print("player " + str(i) + "'s deck")
		for j in players[i]:
			print(j.id)
		
	
	

func send():
	var encodedDeck = []
	var encodedPile = []
	var encodedGarbage = []
	var encodedPlayers = []
	
	for i in deck:
		encodedDeck.push_back(i.id)
		
	for i in pile:
		encodedPile.push_back(i.id)
	
	for i in garbage:
		encodedGarbage.push_back(i.id)
		
	for i in range(num_players):
		encodedPlayers.push_back([])
		
	for i in range(num_players):
		for j in players[i]:
			encodedPlayers[i].push_back(j.id)
		
	var data = [
		encodedDeck, # fine ?
		encodedPlayers, # fine
		encodedPile, # fine ? 
		encodedGarbage, # fine ?
		dutch, # fine
		turn_timer, # big issues
		turn_counter, # fine
		game_state, # fine
		timer_paused,
		checked_cards
	]
	
	rpc("receive", data)
