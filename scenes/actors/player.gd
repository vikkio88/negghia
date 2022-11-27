extends CharacterBody2D

const MIN_AIM_DISTANCE: float = 100.0
const SPRINT_MAX_COST: int = 15

@onready var Body: Sprite2D = $body
@onready var Hand: Node2D = $hand
@onready var Anims: AnimationPlayer = $animations
@onready var noise: AnimationPlayer = $noise/anim
@onready var ft_placeholder: Node2D = $floatph

@export var _speed: float = 100.0

var _speed_malus: float = 1.0

var _is_sprinting = false
var _is_aiming = false

var MaxHealth: int = 100
var _health: int = MaxHealth
var Health: int = _health:
	set = _set_health,
	get = _get_health


func _set_health(value: int):
	_health = clampi(value, 0, MaxHealth)

	if _health == 0:
		EventsBus.game_over.emit()


func _get_health():
	return _health


var _out_of_stamina = false
var MaxStamina: int = 100
var _stamina: int = MaxStamina
var Stamina: int = _stamina:
	set = _set_stamina,
	get = _get_stamina


func _set_stamina(value: int):
	_stamina = clampi(value, 0, MaxStamina)
	if _stamina > SPRINT_MAX_COST:
		_out_of_stamina = false
	if _stamina == 0:
		EventsBus.player_event.emit("Out of Stamina")
		_out_of_stamina = true


func _get_stamina() -> int:
	return _stamina


func _ready() -> void:
	EventsBus.player_event.connect(self.floating_message)
	EventsBus.player_health_update.emit(Health, MaxHealth, 100, 100)
	velocity = Vector2.ZERO


func floating_message(message: String):
	HudFactory.add_floating_text(message, ft_placeholder)


func _physics_process(delta: float) -> void:
	reset_conditions()
	var direction_x := Input.get_axis("left", "right")
	var direction_y = Input.get_axis("up", "down")

	if Input.is_action_pressed("aim") and can_aim():
		aim()

	if Input.is_action_pressed("sprint") and can_sprint():
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
		(
			HudFactory
			. add_floating_text("%d / %d" % [Hand.check_ammo(), Hand.max_ammo()], ft_placeholder)
		)

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
		HudFactory.add_floating_text("Reloading", ft_placeholder)
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


func can_sprint() -> bool:
	return not _is_aiming and not _out_of_stamina


func get_speed() -> float:
	return (_speed * (1 if not _is_sprinting else 2.8)) * _speed_malus


func get_walking_speed() -> float:
	if _is_sprinting:
		Utils.gated_timer("player_consuming_stamina", 1, self.consume_stamina)
		return 1.5
	elif _is_aiming:
		return .5

	return 1.0


func _footstep_adjust() -> void:
	$footstep.set_pitch_scale(randf_range(0.8, 1.8))


func take_damage(dmg: int):
	HudFactory.add_floating_critical("%d" % dmg, ft_placeholder)
	Health -= dmg
	emit_health_update()


func consume_stamina():
	Stamina -= Dice.roll(SPRINT_MAX_COST, SPRINT_MAX_COST / 2)
	emit_health_update()


func recover():
	if not _is_sprinting and not Utils.get_gate_by_name("player_consuming_stamina"):
		Stamina += Dice.roll(5)
		emit_health_update()


func emit_noise(level: Enums.NoiseLevel = Enums.NoiseLevel.Normal) -> void:
	match level:
		Enums.NoiseLevel.Normal:
			noise.play("emit")
		Enums.NoiseLevel.Quiet:
			noise.play("emit_quiet")
		Enums.NoiseLevel.Loud:
			noise.play("emit_loud")


func emit_health_update():
	EventsBus.player_health_update.emit(Health, MaxHealth, Stamina, MaxStamina)


func _on_tick_timeout() -> void:
	recover()
