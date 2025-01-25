extends Resource
class_name CardData

@export var card_value: int = 0
'''
0-7: players 1-8
8: deck (hidden)
9: discard (pile)
'''
@export_range(0, 9) var owner: int = 9

'''
CARD IDS
0-12 HEART
13-25 CLUB
26-38 DIAMOND
39-51 SPADE
52, 53: JOKER
'''

func _init(id: int, _owner = 9):
	card_value = 0 if id >= 52 else (id % 13) + 1
	owner = _owner
