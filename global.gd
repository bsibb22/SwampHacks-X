extends Node

var IMAGE_BANK = {
	"card_0": preload("res://Sprites/ace.png"),
	"CARDBACK": preload("res://Sprites/cardback.png")
}

func load_img(img_key: String) -> CompressedTexture2D:
	if IMAGE_BANK[img_key]:
		return IMAGE_BANK[img_key]
	else:
		print("ERROR: no image found with key %s!" % img_key)
		return CompressedTexture2D.new()

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
	
	pile.push(temp)

var deck = [] # stack
var players: Array[Array] = [] # 2d player array
var pile = []

func load_game(num_players: int) -> void:
	# Create the pile of cards
	for i in range(0, 54):
		# make new card with id i and owner pile
		var c: CardData = CardData.new(i)
		deck.push_back(c)

	# Shuffle the deck
	deck.shuffle()

	# Deal the cards
	for i in range(0, num_players):
		players.push_back([])
		for j in range(0, 3):
			players[i].push_back(deck.pop_back())
			
func _ready() -> void:
	load_game(4)
