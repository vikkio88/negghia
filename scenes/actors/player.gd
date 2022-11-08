extends CharacterBody2D

@onready var Line: Line2D = $Line2D
@onready var Ray: RayCast2D = $RayCast2D
@export var _speed:float = 100.0

var _speed_malus: float = 1.0

var _is_sprinting = false
var _is_aiming = false

func _physics_process(delta: float) -> void:
	reset_conditions()
	var direction_x := Input.get_axis("left", "right")
	var direction_y = Input.get_axis("up", "down");
	
	if Input.is_action_pressed("aim"):
		cast_aim()
	
	if Input.is_action_pressed("sprint") and not _is_aiming:
		_is_sprinting = true
		
	if direction_y or direction_x:
		var direction = Vector2(direction_x, direction_y)
		velocity = direction.normalized() * get_speed()

	else:
		velocity.x = move_toward(velocity.x, 0, get_speed())
		velocity.y = move_toward(velocity.y, 0, get_speed())

	move_and_slide()
	look_at(get_global_mouse_position())
	Ray.global_position = global_position
	Ray.look_at(get_global_mouse_position())

func reset_conditions()->void:
	_is_sprinting = false
	_is_aiming = false
	Line.clear_points()
	_speed_malus = 1.0

func cast_aim()->void:
	_speed_malus = .3
	_is_aiming = true
	Line.add_point(to_local(global_position))
	Line.add_point(get_local_mouse_position())

func get_speed()-> float:
	return (_speed * (1 if not _is_sprinting else 2.8)) *  _speed_malus
