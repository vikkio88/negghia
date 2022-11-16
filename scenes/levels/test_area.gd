extends Node2D

# Load the custom images for the mouse cursor.
@onready var arrow = preload("res://assets/cross.png")


func _ready() -> void:
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW, Vector2(15, 15))
	EventsBus.connect("gun_dropped", self.spawn_gun)


func spawn_gun(type: Enums.Weapons, position: Vector2):
	var weapon = ItemFactory.make_pickable_weapon(type).instantiate()
	weapon.init(position, true)
	add_child(weapon)
