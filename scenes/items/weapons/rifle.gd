extends Node2D

const OPERATIONAL_DISTANCE: float = 80.0
const RIFLE_BULLET_SPEED: float = 1500.0

@onready var Line: Line2D = $sprite/muzzle/aimline
@onready var Ray: RayCast2D = $sprite/muzzle/aimline/aimcast
@onready var Muzzle: Node2D = $sprite/muzzle
@onready var Sprite: Sprite2D = $sprite

@onready var bullet = preload("res://scenes/items/bullet.tscn")


var _is_aiming: bool = false

func set_aim(aiming: bool) -> void:
	_is_aiming = aiming


func _physics_process(delta: float) -> void:
	Line.clear_points()
	Ray.global_position = global_position
	Line.global_position = global_position
	var aimed_point = get_global_mouse_position()
	gun_orientation(aimed_point)
	
	
func gun_orientation(aimed_point: Vector2) -> void:
	Ray.look_at(aimed_point)
	look_at(aimed_point)
	if aimed_point.x < global_position.x:
		Sprite.set_flip_v(true)
		Muzzle.transform.origin.y = 2
	else:
		Sprite.set_flip_v(false)
		Muzzle.transform.origin.y = -2
	
	if _is_aiming:
		aim()

func aim() -> void:
	Line.add_point(to_local(Muzzle.global_position))
	Line.add_point(get_local_mouse_position())

func shoot() ->void:
	var b: Node2D = bullet.instantiate()
	b.global_position = Muzzle.global_position
	get_tree().get_root().add_child(b)
	b.shoot(RIFLE_BULLET_SPEED, _is_aiming)
