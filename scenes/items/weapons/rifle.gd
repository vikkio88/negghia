extends Node2D

const OPERATIONAL_DISTANCE: float = 80.0

@onready var Line: Line2D = $sprite/aimline
@onready var Ray: RayCast2D = $sprite/aimcast
@onready var Muzzle: Node2D = $muzzle

var _is_aiming: bool = false

func set_aim(aiming: bool) -> void:
	_is_aiming = aiming
	

func _physics_process(delta: float) -> void:
	Line.clear_points()
	Ray.global_position = global_position
	Line.global_position = global_position
	var aimed_point = get_global_mouse_position()
	Ray.look_at(aimed_point)
	look_at(aimed_point)
	
	if _is_aiming:
		aim()

func aim() -> void:
	Line.add_point(to_local(Muzzle.global_position))
	Line.add_point(get_local_mouse_position())
