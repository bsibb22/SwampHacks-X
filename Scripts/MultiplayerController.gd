extends Control

@export var port = 8910
var joined = false
var hosting = false
const maxPlayers = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	'''var count = 1
	$"Lobby Text".text = "Lobby (" + str(GameManager.Players.size()) + "/8):"
	for i in GameManager.Players:
		$"Lobby Text".text += "\n" + str(count) + ". " + GameManager.Players[i].name
		count += 1'''
	pass

func player_connected(id) -> void:
	print("Player Connected " + str(id))

	
func player_disconnected(id) -> void:
	print("Player Disconnected " + str(id))
	GameManager.Players.erase(id)
	
func connected_to_server() -> void:
	print("Connected to Server")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())	
	
func connection_failed() -> void:
	print("Connection Failed")
	
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
 
func _on_host_button_down() -> void:
	if !hosting:
		GameManager.peer = ENetMultiplayerPeer.new()
		var error = GameManager.peer.create_server(port, maxPlayers)
		if error != OK:
			print("Cannot host: " + str(error))
			return
		GameManager.peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
		multiplayer.set_multiplayer_peer(GameManager.peer)
		print("Waiting for Players")
		SendPlayerInformation("", multiplayer.get_unique_id())
		hosting = true
		get_tree().change_scene_to_file("res://Scenes/host_menu.tscn")
		

func _on_close_button_down() -> void:
	if multiplayer.is_server():
		$Label3.text = "No longer hosting"
	else:
		$Label3.text = "Host is no longer hosting"
	for i in GameManager.Players:
		multiplayer.multiplayer_peer.disconnect_peer(GameManager.Players[i].id)
	GameManager.Players.clear()
	multiplayer.set_multiplayer_peer(null)
	hosting = false
	GameManager.playerCount = 0


func _on_back_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
func get_player_name(id):
	pass


func _on_join_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/join_menu_1.tscn")
