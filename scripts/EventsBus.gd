extends Node

signal interactable_on(item: String, action: String, callback: Callable)
signal interactable_off(callback: Callable)

signal gun_pickup(item: String)

func _ready() -> void:
	pass
