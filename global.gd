extends Node

@onready var IMAGE_BANK = {
	"HEART_A": load("res://Sprites/ace.png"),
	"CARDBACK": load("res://Sprites/cardback.png")
}

func load_img(img_key: String) -> Sprite2D:
	if IMAGE_BANK[img_key]:
		return IMAGE_BANK[img_key]
	else:
		print("ERROR: no image found with key %s!" % img_key)
		return Sprite2D.new()

func shuffle_deck() -> void:
	# save the most recently played card
	var temp = pile.pop_back()

	# randomly add cards from the discard pile to the deck
	while pile.length() > 0:
		var c = pile.pick_random()
		if (c == temp):
			continue
		c.owner = 8
		deck.push(c)

var deck = [] # stack
var players = [] # 2d player array
var pile = []

func load_game(num_players: int) -> void:
	# Create the pile of cards
	for i in range(0, 54):
	# make new card with id i and owner pile
		var c: CardData = CardData.new(i)
		deck.push(c)

	# Shuffle the deck
	deck.shuffle()

	# Deal the cards
	for i in range(0, num_players):
		players[i] = []
		for j in range(0, 3):
			players[i].push(deck.pop_back())
