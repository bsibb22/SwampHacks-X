extends Control

@rpc("any_peer")
func SendPlayerInformation(name, id):
	print("Name: " + name + " ID: " + str(id))
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name" : name,
			"id" : id
		}
		
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_join_button_down() -> void:
	GameManager.peer = ENetMultiplayerPeer.new()
	var error = GameManager.peer.create_client($LineEdit.text, 8910)
	if error != OK:
		print("Cannot connect: " + str(error))
		return
	GameManager.peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(GameManager.peer)
	SendPlayerInformation.rpc_id(1, "", multiplayer.get_unique_id())
	get_tree().change_scene_to_file("res://Scenes/join_menu_2.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/multiplayer_options.tscn")
	
@rpc("any_peer", "call_local")
func StartGame() -> void:
	'''var scene = load("res://Scenes/game.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()'''
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
