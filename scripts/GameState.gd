extends Node

var is_game_started = false
var is_game_over = false

func game_over():
	EventsBus.emit_signal("game_over")
