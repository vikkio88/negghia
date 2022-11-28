extends CanvasLayer

func _enter_tree() -> void:
	print(GameState.get_stats())
#	print("GameOver:\n stats\nkills: %d, head: %d, hits: %d, shots: %d" % [kills, headshots, hits, shots])

func restart():
	GameState.reset()
	get_tree().change_scene_to_file("res://scenes/levels/test_area.tscn")

func _on_restart_button_up() -> void:
	restart()
