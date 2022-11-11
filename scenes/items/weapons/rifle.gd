extends Node2D

const OPERATIONAL_DISTANCE: float = 80.0
const RIFLE_BULLET_SPEED: float = 1500.0

const RECOIL_MULTIPLIER: float = 40.0

const MAX_AMMO: int = 5

@onready var Line: Line2D = $sprite/muzzle/aimline
@onready var Ray: RayCast2D = $sprite/muzzle/aimline/aimcast
@onready var Muzzle: Node2D = $sprite/muzzle
@onready var Sprite: Sprite2D = $sprite
@onready var anim: AnimationPlayer = $anim

@onready var shoot_sound: AudioStreamPlayer = $shoot
@onready var dry_sound: AudioStreamPlayer = $dryfire

@onready var bullet = preload("res://scenes/items/bullet.tscn")

var _ammo: int = 5

var _is_aiming: bool = false
var _can_fire = true

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

func shoot() -> Vector2:
	if not _can_fire:
		return Vector2.ZERO
	
	if not has_ammo():
		shoot_sound.set_pitch_scale(randf_range(.8,1.5))
		dry_sound.play()
		return Vector2.ZERO
		
	_can_fire = false
	shoot_sound.set_pitch_scale(randf_range(1.8,2.2))
	var b: Node2D = bullet.instantiate()
	b.global_position = Muzzle.global_position
	get_tree().get_root().add_child(b)
	b.shoot(RIFLE_BULLET_SPEED, _is_aiming)
	anim.play("shoot")
	return Vector2(randi_range(-RECOIL_MULTIPLIER,RECOIL_MULTIPLIER),randi_range(-RECOIL_MULTIPLIER,RECOIL_MULTIPLIER))

func reset_can_shoot() -> void:
	_can_fire = true
	use_ammo()

func use_ammo()-> void:
	_ammo -= 1
	if _ammo <= 0:
		_ammo = 0
		anim.play("clip_eject")

func set_ammo(ammo: int) -> void:
	_ammo = min(MAX_AMMO, ammo)

func has_ammo() -> bool:
	return _ammo > 0

func reload_start() ->void:
	anim.play("reload")
	
func reload() -> void:
	set_ammo(MAX_AMMO)
	
