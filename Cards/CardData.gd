extends Resource
class_name CardData

@export_range(0, 13) var card_value = 0
@export_range(0, 53) var id = 0
'''
0-7: players 1-8
8: deck (hidden)
9: discard (pile)
10: mistake cards
'''
@export_range(0, 10) var owner: int = 8

'''
CARD IDS
0-12 HEART
13-25 CLUB
26-38 DIAMOND
39-51 SPADE
52, 53: JOKER
'''

func _init(_id: int, _owner = 9):
	card_value = 0 if id >= 52 else (id % 13) + 1
	id = _id
	owner = _owner

func update_owner(pid):
	owner = pid
