extends Node

@onready var IMAGE_BANK = {
  "HEART_A": load("res://Sprites/ace.png"),
  "CARDBACK": load("res://Sprites/card_-1.png")
}

func load_img(img_key: int = -1) -> Sprite2D:
	var img_name = "card_" + str(img_key)
	if IMAGE_BANK[img_name]:
		return IMAGE_BANK[img_name]
	else:
		print("ERROR: no image found with key %s!" % img_key)
		return Sprite2D.new()

func shuffle_deck() -> void:
	# Save the most recently played card
	var temp = pile.pop_back()

	# Randomly add cards from the discard pile to the deck
	while pile.size() > 0:
		var c = pile.pick_random()
		if (c == temp):
			continue
		c.owner = 8
		deck.push(c)
	
	pile.push(temp)


func deal_card(player_id, num_cards) -> void:
	for i in range(num_cards):
		players[player_id].push(deck.pop)
		if(deck.size() < 1):
			shuffle_deck()

# ---- #

var deck = [] # stack
var players = [] # 2d player array
var pile = []

func load_game(num_players: int) -> void:
	# Create the pile of cards
	for i in range(54):
		# make new card with id i and owner pile
		var c: CardData = CardData.new(i)
		deck.push(c)

	# Shuffle the deck
	deck.shuffle()

	# Deal the cards
	for i in range(num_players):
		players[i] = []
		for j in range(3):
			players[i].push(deck.pop_back())
