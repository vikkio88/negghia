extends CharacterBody2D

const MIN_AIM_DISTANCE: float = 100.0

@onready var ftext = preload("res://scenes/hud/floating_text.tscn")

@onready var Body: Sprite2D = $body
@onready var Hand: Node2D = $hand
@onready var Anims: AnimationPlayer = $animations
@onready var noise: AnimationPlayer = $noise/anim
@onready var floatph: Node2D = $floatph

@export var _speed: float = 100.0

var _speed_malus: float = 1.0

var _is_sprinting = false
var _is_aiming = false


func _ready() -> void:
	EventsBus.connect("player_event", self.trigger_floating_message)
	velocity = Vector2.ZERO


func _physics_process(delta: float) -> void:
	reset_conditions()
	var direction_x := Input.get_axis("left", "right")
	var direction_y = Input.get_axis("up", "down")

	if Input.is_action_pressed("aim") and can_aim():
		aim()

	if Input.is_action_pressed("sprint") and not _is_aiming:
		_is_sprinting = true

	if direction_y or direction_x:
		var direction = Vector2(direction_x, direction_y)
		velocity = direction.normalized() * get_speed()

	if velocity == Vector2.ZERO:
		# TODO: GET A STILL ANIMATION GOING
		#Anims.play("idle" if not _is_aiming else "idle")
		Anims.play("still")
	else:
		Anims.play("walk", -1, get_walking_speed())

	handle_gun_controls()

	if Input.is_action_just_released("q") and Hand.has_gun():
		trigger_floating_message("%d / %d" % [Hand.check_ammo(), Hand.max_ammo()])

	move_and_slide()
	adjust_orientation()


func handle_gun_controls() -> void:
	if not Hand.has_gun():
		return

	var shoot_input = (
		Input.is_action_just_released("shoot")
		if Hand.is_gun_semi_auto()
		else Input.is_action_pressed("shoot")
	)
	if not _is_sprinting and shoot_input and can_aim():
		Hand.shoot()
	elif not _is_sprinting and Input.is_action_just_released("reload"):
		trigger_floating_message("Reloading")
		Hand.reload()

	if Input.is_action_just_released("g"):
		Hand.release_gun()


func adjust_orientation() -> void:
	if get_aimed_point().x < global_position.x:
		Body.set_flip_h(true)
		Hand.position.x = -30
	else:
		Body.set_flip_h(false)
		Hand.position.x = 30


func get_aimed_point() -> Vector2:
	return get_global_mouse_position()


func reset_conditions() -> void:
	velocity = Vector2.ZERO
	_is_sprinting = false
	_is_aiming = false
	Hand.set_aim(false)
	_speed_malus = 1.0


func can_aim() -> bool:
	return global_position.distance_to(get_aimed_point()) > MIN_AIM_DISTANCE


func aim() -> void:
	_speed_malus = .15
	_is_aiming = true
	Hand.set_aim(true)


func get_speed() -> float:
	return (_speed * (1 if not _is_sprinting else 2.8)) * _speed_malus


func get_walking_speed() -> float:
	if _is_sprinting:
		return 1.5
	elif _is_aiming:
		return .5

	return 1.0


func trigger_floating_message(message: String) -> void:
	var t = ftext.instantiate()
	floatph.add_child(t)
	t.trigger(message)


func _footstep_adjust() -> void:
	$footstep.set_pitch_scale(randf_range(0.8, 1.8))

func emit_noise(level: Enums.NoiseLevel = Enums.NoiseLevel.Normal) -> void:
	match level:
		Enums.NoiseLevel.Normal:
			noise.play("emit")
		Enums.NoiseLevel.Quiet:
			noise.play("emit_quiet")
		Enums.NoiseLevel.Loud:
			noise.play("emit_loud")
