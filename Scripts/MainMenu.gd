extends Node

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/multiplayer_options.tscn")


func _on_quit_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
