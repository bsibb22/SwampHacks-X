extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_start_button_down() -> void:
	for i in GameManager.Players:
		print("Name: " + GameManager.Players[i].name + " ID: " + str(GameManager.Players[i].id))
	StartGame.rpc()
	
@rpc("any_peer", "call_local")
func StartGame() -> void:
	'''var scene = load("res://Scenes/game.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()'''
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	
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
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
