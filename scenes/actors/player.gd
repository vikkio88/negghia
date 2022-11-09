extends CharacterBody2D

const MIN_AIM_DISTANCE: float = 100.0

@onready var Hand: Node2D = $hand/aimcast


@export var _speed:float = 100.0

var _speed_malus: float = 1.0

var _is_sprinting = false
var _is_aiming = false

func _physics_process(delta: float) -> void:
	reset_conditions()
	var direction_x := Input.get_axis("left", "right")
	var direction_y = Input.get_axis("up", "down");
	
	if Input.is_action_pressed("aim") and can_aim():
		aim()
	
	if Input.is_action_pressed("sprint") and not _is_aiming:
		_is_sprinting = true
		
	if direction_y or direction_x:
		var direction = Vector2(direction_x, direction_y)
		velocity = direction.normalized() * get_speed()

	else:
		velocity.x = move_toward(velocity.x, 0, get_speed())
		velocity.y = move_toward(velocity.y, 0, get_speed())

	move_and_slide()
	if global_position.distance_to(get_aimed_point()) > MIN_AIM_DISTANCE:
		look_at(get_aimed_point())

func get_aimed_point()-> Vector2:
	return get_global_mouse_position()

func reset_conditions()->void:
	_is_sprinting = false
	_is_aiming = false
	$hand/rifle.set_aim(false)
	_speed_malus = 1.0

func can_aim() -> bool:
	return global_position.distance_to(get_aimed_point()) > MIN_AIM_DISTANCE

func aim()->void:
	_speed_malus = .3
	_is_aiming = true
	$hand/rifle.set_aim(true)


func get_speed()-> float:
	return (_speed * (1 if not _is_sprinting else 2.8)) *  _speed_malus
