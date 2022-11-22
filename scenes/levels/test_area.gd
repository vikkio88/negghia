extends Node2D

# Load the custom images for the mouse cursor.
@onready var arrow = preload("res://assets/cross.png")
@onready var enemy_scene = preload("res://scenes/actors/enemy.tscn")

@onready var enemies_node: Node = $MapNavigation/enemies
@onready var spawn_point : Vector2 = $spawn_point.position

var _enemy_count = 4
var _max_enemies = 10

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_point
	enemies_node.add_child(enemy)


func _ready() -> void:
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW, Vector2(15, 15))
	EventsBus.connect("gun_dropped", self.spawn_gun)


func spawn_gun(type: Enums.Weapons, position: Vector2, ammo_left: int = 0):
	var weapon = ItemFactory.make_pickable_weapon(type).instantiate()
	weapon.init(position, true, ammo_left)
	add_child(weapon)


func _on_tick_timeout() -> void:
	_enemy_count = enemies_node.get_children().size()
	if _enemy_count < _max_enemies:
		spawn_enemy()
