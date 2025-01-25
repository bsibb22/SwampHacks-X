extends Control

@export var Address = "127.0.0.1"
@export var port = 8910
var peer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func player_connected(id) -> void:
	print("Player Connected " + str(id))
	
func player_disconnected(id) -> void:
	print("Player Disconnected " + id)
	
func connected_to_server() -> void:
	print("Connected to Server")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())	
	
func connection_failed() -> void:
	print("Connection Failed")
	
@rpc("any_peer", "call_local")
func StartGame() -> void:
	var scene = load("res://test_scene.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
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
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 8)
	if error != OK:
		print("Cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for Players")
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())
	pass # Replace with function body.


func _on_join_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	pass # Replace with function body.


func _on_start_button_down() -> void:
	for i in GameManager.Players:
		print("Name: " + GameManager.Players[i].name + " ID: " + str(GameManager.Players[i].id))
	StartGame.rpc()
	pass # Replace with function body.
