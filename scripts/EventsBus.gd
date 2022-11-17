extends Node

signal interactable_on(item: String, action: String, callback: Callable)
signal interactable_off(callback: Callable)

signal gun_pickup(type: Enums.Weapons, ammo: int)
signal gun_dropped(type: Enums.Weapons, position: Vector2, ammo_left: int)

signal player_event(message: String)

func _ready() -> void:
	pass
