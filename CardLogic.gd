extends Node2D

signal player_dealt(_pid)

@onready var IMAGE_BANK = []
@onready var CARDBACK = load("res://Sprites/card_-1.png")

func load_img(id: int) -> CompressedTexture2D:
	if(id == -1):
		return CARDBACK
	else:
		return IMAGE_BANK[id]

func shuffle_deck() -> void:
	# Save the most recently played card
	var temp = pile.pop_back()

	# Randomly add cards from the discard pile to the deck
	while pile.size() > 0:
		var c = pile.pick_random()
		if (c == temp):
			continue
		c.owner = 8
		deck.push_back(c)
	
	pile.push_back(temp)


func deal_card(player_id, num_cards) -> void:
	for i in range(num_cards + 1):
		players[player_id].push_back(deck.pop_back())
		$Player.update_hand()
		if(deck.size() < 1):
			shuffle_deck()

# ---- #

var deck = [] # stack
var players = [] # 2d player array
var pile = []

func initialize(num_players: int) -> void:
	# Create the pile of cards
	for i in range(54):
		# make new card with id i and owner pile
		var c: CardData = CardData.new(i) # change to i after card images are added
		IMAGE_BANK.push_back(load("res://Sprites/card_" + str(i) + ".png"))
		deck.push_back(c)

	# Shuffle the deck
	deck.shuffle()

	# Deal the cards
	for i in range(num_players):
		players.push_back([])
		deal_card(i, 3)
		print(players[i])
			
func _ready():
	var num_players = 4
	initialize(num_players)
	
