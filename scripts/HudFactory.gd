extends Node

@onready var ftext = preload("res://scenes/hud/floating_text.tscn")

func add_floating_text(message: String, point: Node2D):
	var t = ftext.instantiate()
	point.add_child(t)
	t.trigger(message)

func add_floating_text_time(message: String, point: Node2D, duration: float):
	var t = ftext.instantiate()
	point.add_child(t)
	t.trigger(message, duration)
	
func add_floating_critical(message: String, point: Node2D):
	var t = ftext.instantiate()
	point.add_child(t)
	t.trigger_critical(message)

func add_floating_critical_time(message: String, point: Node2D, duration: float):
	var t = ftext.instantiate()
	point.add_child(t)
	t.trigger_critical(message, duration)
