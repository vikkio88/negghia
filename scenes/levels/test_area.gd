extends Node2D

# Load the custom images for the mouse cursor.
@onready var arrow = preload("res://assets/cross.png")
@onready var enemy_scene = preload("res://scenes/actors/enemy.tscn")

@onready var enemies_node: Node = $MapNavigation/enemies
@onready var spawn_point: Vector2 = $spawn_point.position
@onready var tick: Timer = $tick
@onready var wave_reset: Timer = $wave_reset

var _max_enemies = 15

var _wave_count = 1
var _wave_length = 15

var _wave_mod = 3
var _ticks = 0


func _ready() -> void:
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW, Vector2(15, 15))
	(
		EventsBus
		. game_over
		. connect(
			func(): get_tree().change_scene_to_file("res://scenes/levels/screens/game_over.tscn")
		)
	)
	EventsBus.gun_dropped.connect(self.spawn_gun)


func spawn_gun(type: Enums.Weapons, gun_position: Vector2, ammo_left: int = 0):
	var weapon = ItemFactory.make_pickable_weapon(type).instantiate()
	weapon.init(gun_position, true, ammo_left)
	add_child(weapon)


func _on_tick_timeout() -> void:
	_ticks += 1
	update_game_info()
	if _ticks >= _wave_length:
		wave_finished()
		return

	if _ticks > 1 and _ticks % _wave_mod != 0:
		print_debug("wave not spawning %d" % _ticks)
		return
	spawn_enemy()


func wave_finished():
	update_game_info()
	tick.stop()

	if get_enemy_count() > 0:
		print_debug("we still have enemies left %d" % get_enemy_count())
		Utils.timer(1, self.wave_finished)
		return

	EventsBus.game_event.emit("Wave %d finished" % _wave_count)
	_ticks = 0
	_wave_count += 1
	var new_mod = _wave_mod - 2
	_wave_mod = clampi(new_mod, 1, 5)

	wave_reset.start()


func spawn_enemy():
	print_debug("wave might spawn %d" % _ticks)
	if get_enemy_count() < _max_enemies * _wave_count:
		print_debug("wave did spawn %d as enemies are: %d" % [_ticks, get_enemy_count()])
		var enemy = enemy_scene.instantiate()
		enemy.global_position = spawn_point
		enemies_node.add_child(enemy)


func _on_wave_reset_timeout() -> void:
	EventsBus.game_event.emit("Wave %d" % _wave_count)
	tick.start()


func get_enemy_count() -> int:
	return enemies_node.get_children().size()


func update_game_info():
	(
		EventsBus
		. game_info
		. emit(
			(
				"wave %d\ntime left : %d\nenemies: %d / %d"
				% [_wave_count, _wave_length - _ticks, get_enemy_count(), _max_enemies]
			)
		)
	)
