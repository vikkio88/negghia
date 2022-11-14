extends RigidBody2D

var _starting_point: Vector2

const MAX_DISTANCE: float = 2000
const DEVIATION_MULTIPLIER = 0.05
@onready var hole_scene = preload("res://scenes/items/bullethole.tscn")


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
	set_freeze_enabled(true)
	if body.has_method("hit"):
		body.hit(global_position)
		var hole = hole_scene.instantiate()
		body.add_child(hole)
		hole.global_position = global_position
	queue_free()
