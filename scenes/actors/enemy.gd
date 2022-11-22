extends CharacterBody2D

const ACCEPTABLE_DISTANCE_TARGET = 109.0
const MAX_ATTEMPTS = 3
const HORIZON_DISTANCE = 90000

var MaxHealth :int = 100;
var _health :int = MaxHealth
var Health :int = _health : set = _set_health, get = _get_health

var _player_ref = null
var _last_player_position = null
var _last_player_noise = null
var _patrol_target = null

const WALK_SPEED : int = 100.0
const RUN_SPEED : int = 200.0

var state: Enums.AIState = Enums.AIState.Patrol

var _reaching_attempts = 0
var _last_distance = HORIZON_DISTANCE


@onready var ftext = preload("res://scenes/hud/floating_text.tscn")

@onready var body: CollisionShape2D = $body
@onready var head: CollisionShape2D = $head
@onready var detector: Area2D = $player_detector
@onready var ft_placeholder: Node2D = $placeholder
@onready var anim: AnimationPlayer = $anim
@onready var navigator: NavigationAgent2D = $navigation

const HEADSHOT_THRESHOLD: float = 23.0
const BODYSHOT_THRESHOLD: float = 60.0

func _ready() -> void:
	_patrol_target = global_position + Vector2(randi_range(100,200), randi_range(100,200))

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if _health <= 0:
		return

	if state != Enums.AIState.Idle:
		var point = get_target()
		navigator.target_location = point
		var location = navigator.get_next_location()
		var speed = RUN_SPEED if _last_player_position != null else WALK_SPEED
		var direction = position.direction_to(location)
		velocity = direction * speed
		move_and_slide()
		
		var distance = position.distance_to(point)
#		_last_distance = distance
#		if abs(_last_distance - distance) < 2:
#			_reaching_attempts += 1
#			if _reaching_attempts >= MAX_ATTEMPTS:
#				_change_state(Enums.AIState.Idle)
		
		print("distance %f" % distance )
		if distance < ACCEPTABLE_DISTANCE_TARGET and _player_ref == null:
			_change_state(Enums.AIState.Idle)
		elif _player_ref != null and distance < ACCEPTABLE_DISTANCE_TARGET:
			message("attacking")

func get_target():
	if _player_ref != null:
		return _player_ref.global_position
		
	if _last_player_position != null:
		return _last_player_position
	
	if _last_player_noise != null:
		return _last_player_noise
	
	return _patrol_target


func hit(point: Vector2, base_dmg: float) -> void:
	var head_d = head.global_position.distance_to(point)
	var body_d = body.global_position.distance_to(point)
	var type = "body shot"
	var damage = base_dmg
	if head_d < HEADSHOT_THRESHOLD or head_d < body_d:
		type = "Headshot!"
		damage *= 2
	message("%s - %d" % [type, damage])
	Health -= damage

func dead():
	queue_free()

func disable() -> void:
	body.disabled = true
	head.disabled = true
	detector.monitoring = false


func _on_player_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		_change_state(Enums.AIState.Investigate)
		_last_player_noise = area.global_position
		if area.global_position.x < global_position.x:
			$sprite.set_flip_h(true)
		else:
			$sprite.set_flip_h(false)


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_ref = body
		_change_state(Enums.AIState.Chase)
		_last_player_position = body.global_position


func _set_health(value: int):
	if value < 0:
		_health = 0
	else:
		_health = value
	
	if _health == 0:
		disable()
		anim.play("die")
		
func _get_health():
	return _health


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_ref = null
		_change_state(Enums.AIState.Patrol)

func _change_state(new_state: Enums.AIState)-> void:
	state = new_state
	message("%s" % Enums.ai_state_to_string(state))
	
	match state:
		Enums.AIState.Idle:
			_player_ref = null
			_reaching_attempts = 0
			_last_distance = HORIZON_DISTANCE
			_last_player_position = null
			_last_player_noise = null
		_:
			print(Enums.ai_state_to_string(state))


func _on_tick_timeout() -> void:
	if state == Enums.AIState.Idle:
		_patrol_target = global_position + Vector2(randi_range(-200,200), randi_range(-200,200))
		_change_state(Enums.AIState.Patrol)
		

func message(msg: String):
	var t = ftext.instantiate()
	ft_placeholder.add_child(t)
	t.trigger(msg)
