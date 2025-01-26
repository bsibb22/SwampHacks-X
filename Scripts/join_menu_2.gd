extends Control
var joined = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
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


func _on_back_pressed() -> void:
	GameManager.Players.erase(multiplayer.get_unique_id())
	multiplayer.multiplayer_peer.disconnect_peer(1)
	GameManager.Players.clear()
	get_tree().change_scene_to_file("res://Scenes/join_menu_1.tscn")
