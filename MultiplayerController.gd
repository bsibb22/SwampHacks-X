extends Control

@export var Address = "127.0.0.1"
@export var port = 8910

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
	print("Player Connected " + id)
	
func player_disconnected(id) -> void:
	print("Player Disconnected " + id)
	
func connected_to_server(id) -> void:
	print("Connected to Server " + id)
	
func connection_failed(id) -> void:
	print("Connection Failed " + id)
 
func _on_host_button_down() -> void:
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 8)
	if error != OK:
		print("Cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	pass # Replace with function body.


func _on_join_button_down() -> void:
	pass # Replace with function body.


func _on_start_button_down() -> void:
	pass # Replace with function body.
