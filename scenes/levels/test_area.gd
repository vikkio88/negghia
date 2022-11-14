extends Node2D

# Load the custom images for the mouse cursor.
@onready var arrow = preload("res://assets/cross.png")
@onready var pickable_scene = preload("res://scenes/items/pickable.tscn")


func _ready() -> void:
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW, Vector2(15, 15))
	(
		EventsBus
		. connect(
			"interactable_on",
			func(item: String, action: String, callback: Callable): print("%s, %s" % [item, action])
		)
	)

	EventsBus.connect("interactable_off", func(): print("NO MORE"))

	EventsBus.connect("gun_dropped", self.spawn_gun)


func spawn_gun(type: Enums.Weapons, position: Vector2):
	if type == Enums.Weapons.Rifle:
		var rifle = pickable_scene.instantiate()
		rifle.init(position, true)
		add_child(rifle)
