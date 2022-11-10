extends RigidBody2D

var _starting_point: Vector2

const MAX_DISTANCE:float = 2000
const DEVIATION_MULTIPLIER = 0.08


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_starting_point = transform.origin

func shoot(speed: float, precision: bool) -> void:
	look_at(get_global_mouse_position())
	var deviation = 0
	if not precision:
		var deviation_angle = PI * DEVIATION_MULTIPLIER
		deviation = randf_range(-deviation_angle, deviation_angle)
	apply_impulse(Vector2(speed, 0).rotated(rotation + deviation))



func _physics_process(delta: float) -> void:
	if transform.origin.distance_to(_starting_point) > MAX_DISTANCE:
		print("BULLET OUT OF BOUNDS")
		queue_free()

func _on_area_body_entered(body: Node2D) -> void:
	print("hit something")
	queue_free()
