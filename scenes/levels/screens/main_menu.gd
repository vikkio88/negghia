extends CanvasLayer


func _on_test_room_button_up() -> void:
	GameState.reset()
	get_tree().change_scene_to_file("res://scenes/levels/test_area.tscn")


func _on_exit_button_up() -> void:
	get_tree().quit()
