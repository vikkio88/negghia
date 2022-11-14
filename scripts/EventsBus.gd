extends Node

signal interactable_on(item: String, action: String, callback: Callable)
signal interactable_off(callback: Callable)

signal gun_pickup(item: Enums.Weapons)

func _ready() -> void:
	pass
