extends Node2D

signal update

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
	
	
# ---- #

var deck = [] # stack
var players = [] # 2d player array
var pile = [] # face up pile of cards you can choose from
var garbage = [] # cards that have been lost to time

func _ready() -> void:
	# Create the pile of cards
	for i in range(54):
		# make new card with id i and owner pile
		var c: CardData = CardData.new(i) # change to i after card images are added
		IMAGE_BANK.push_back(load("res://Sprites/card_" + str(i) + ".png"))
		deck.push_back(c)

	# Shuffle the deck
		deck.shuffle()
	
	# Deal the cards
	for i in range(global.num_players):
		players.push_back([])
		deal_card(i, 4)
		print(players[i])
