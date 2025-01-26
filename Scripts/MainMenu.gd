extends Node

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MultiplayerControl.tscn")
	


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
