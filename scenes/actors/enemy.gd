extends CharacterBody2D

const ACCEPTABLE_DISTANCE_TARGET = 109.0

const PATROL_DISTANCE = 500

var Dmg: int = 15

var MaxHealth: int = 100
var _health: int = MaxHealth
var Health: int = _health:
	set = _set_health,
	get = _get_health


func _set_health(value: int):
	if value < 0:
		_health = 0
	else:
		_health = value

	if _health == 0:
		GameState.stat_update.emit(GameState.Stats.Kills)
		disable()
		anim.play("die")


func _get_health():
	return _health


var _player_ref = null
var _last_player_position = null
var _last_player_noise = null
var _patrol_target = null

const WALK_SPEED: int = 100.0
const RUN_SPEED: int = 200.0

var state: Enums.AIState = Enums.AIState.Patrol

@onready var body: CollisionShape2D = $body
@onready var head: CollisionShape2D = $head
@onready var detector: Area2D = $player_detector
@onready var ft_placeholder: Node2D = $placeholder
@onready var anim: AnimationPlayer = $anim
@onready var navigator: NavigationAgent2D = $navigation
@onready var sprite: Sprite2D = $sprite
@onready var tick: Timer = $tick

const HEADSHOT_THRESHOLD: float = 23.0
const BODYSHOT_THRESHOLD: float = 60.0


func _ready() -> void:
	_patrol_target = global_position + Vector2(randi_range(100, 200), randi_range(100, 200))


func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if _health <= 0:
		return

	if state == Enums.AIState.Attack:
		anim.play("attack")
		var point = get_target()
		if _player_ref == null or position.distance_to(point) > ACCEPTABLE_DISTANCE_TARGET:
			_change_state(Enums.AIState.Chase)
		return

	if state == Enums.AIState.Idle:
		anim.play("idle")
		return

	var point = get_target()
	
	navigator.target_position = point
	var location = navigator.get_next_path_position()

	var speed = RUN_SPEED if _last_player_position != null else WALK_SPEED
	var direction = position.direction_to(location)
	velocity = direction * speed
	anim.play("walk")
	move_and_slide()
	check_target_reach()


func get_target():
	if _player_ref != null:
		return _player_ref.global_position

	if _last_player_position != null:
		return _last_player_position

	if _last_player_noise != null:
		return _last_player_noise

	return _patrol_target


# STARTING ENEMY HITTING LOGIC
func hit(point: Vector2, base_dmg: float) -> void:
	if Health == 0:
		return

	GameState.stat_update.emit(GameState.Stats.Hits)
	var head_d = head.global_position.distance_to(point)
	var body_d = body.global_position.distance_to(point)
	var type = "body shot"
	var damage = base_dmg
	if head_d < HEADSHOT_THRESHOLD or head_d < body_d:
		type = "Headshot!"
		GameState.stat_update.emit(GameState.Stats.Headshots)
		damage *= 2
	HudFactory.add_floating_critical("%s - %d" % [type, damage], ft_placeholder)
	Health -= damage


func add_hole(hole: Node2D):
	hole.apply_scale(Vector2(.3, .3))
	hole.is_blood()
	sprite.add_child(hole)


# END OF ENEMY HITTING LOGIC


func dead():
	Utils.dispose_gated_timer("%s_enemy_attack" % get_instance_id())
	queue_free()


func disable() -> void:
	tick.stop()
	body.disabled = true
	head.disabled = true
	detector.monitoring = false


func _on_player_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		_change_state(Enums.AIState.Investigate)
		_last_player_noise = area.global_position
		if area.global_position.x < global_position.x:
			sprite.set_flip_h(true)
		else:
			sprite.set_flip_h(false)


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_ref = body
		_change_state(Enums.AIState.Chase)
		_last_player_position = body.global_position


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_ref = null
		_change_state(Enums.AIState.Patrol)


func _change_state(new_state: Enums.AIState) -> void:
	state = new_state
	HudFactory.add_floating_text("state: %s" % Enums.ai_state_to_string(state), ft_placeholder)
	if state == Enums.AIState.Attack:
		tick.wait_time = .5
		tick.stop()
		tick.start()
		attack()

	match state:
		Enums.AIState.Idle:
			tick.wait_time = 5
			_player_ref = null
			_last_player_position = null
			_last_player_noise = null
		_:
			pass


func attack():
	if _player_ref and _player_ref.has_method("take_damage"):
		Utils.gated_timer("%s_enemy_attack" % get_instance_id(), 1, self.damage_player)


func damage_player():
	if _player_ref != null:
		_player_ref.take_damage(Dice.roll(Dmg))


func get_random_patrol_point():
	return (
		global_position
		+ Vector2(
			randi_range(-PATROL_DISTANCE, PATROL_DISTANCE),
			randi_range(-PATROL_DISTANCE, PATROL_DISTANCE)
		)
	)


func _on_tick_timeout() -> void:
	if state == Enums.AIState.Idle:
		_patrol_target = get_random_patrol_point()
		_change_state(Enums.AIState.Patrol)
		return

	if state == Enums.AIState.Patrol:
		_patrol_target = get_random_patrol_point()
		_change_state(Enums.AIState.Patrol)
		return

	check_target_reach()


func check_target_reach():
	var point = get_target()
	var distance = position.distance_to(point)
	if distance < ACCEPTABLE_DISTANCE_TARGET and _player_ref == null:
		_change_state(Enums.AIState.Idle)
	elif _player_ref != null and distance < ACCEPTABLE_DISTANCE_TARGET:
		_change_state(Enums.AIState.Attack)
