extends Node2D

class_name BaseWeapon

const OPERATIONAL_DISTANCE: float = 80.0

@onready var Line: Line2D = $sprite/muzzle/aimline
@onready var Ray: RayCast2D = $sprite/muzzle/aimline/aimcast
@onready var Muzzle: Node2D = $sprite/muzzle
@onready var Sprite: Sprite2D = $sprite
@onready var anim: AnimationPlayer = $anim

@onready var shoot_sound: AudioStreamPlayer = $shoot
@onready var dry_sound: AudioStreamPlayer = $dryfire

@onready var bullet = preload("res://scenes/items/bullet.tscn")

@export var Equipped: bool = false

var Is_semi_auto = true
var Type: Enums.Weapons = Enums.Weapons.Rifle
var Bullet_speed: float = 2500.0
var Recoil_Multiplier: float = 40.0
var Max_ammo: int = 5

var _ammo: int = 5
var _is_aiming: bool = false
var _can_fire = true
var _is_reloading = false


func _ready() -> void:
	Line.clear_points()


func set_aim(aiming: bool) -> void:
	_is_aiming = aiming


func _physics_process(delta: float) -> void:
	if not Equipped:
		return
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
	if _is_reloading:
		return Vector2.ZERO

	if not _can_fire:
		return Vector2.ZERO

	if not has_ammo():
		shoot_sound.set_pitch_scale(randf_range(.8, 1.5))
		dry_sound.play()
		return Vector2.ZERO

	_can_fire = false
	shoot_sound.set_pitch_scale(randf_range(1.8, 2.2))
	var b: Node2D = bullet.instantiate()
	b.global_position = Muzzle.global_position
	get_tree().get_root().add_child(b)
	b.shoot(Bullet_speed, _is_aiming)
	anim.play("shoot")
	return Vector2(
		randi_range(-Recoil_Multiplier, Recoil_Multiplier),
		randi_range(-Recoil_Multiplier, Recoil_Multiplier)
	)


func reset_can_shoot() -> void:
	_can_fire = true
	use_ammo()


func use_ammo() -> void:
	_ammo -= 1
	if _ammo <= 0:
		_ammo = 0
		anim.play("clip_eject")


func set_ammo(ammo: int) -> void:
	_ammo = min(Max_ammo, ammo)


func has_ammo() -> bool:
	return _ammo > 0


func reload_start() -> void:
	_is_reloading = true
	anim.play("reload")


func reload() -> void:
	_is_reloading = false
	set_ammo(Max_ammo)
	EventsBus.emit_signal("player_event", "Reloded: %s / %s" % [_ammo, Max_ammo])


func equipped() -> void:
	Equipped = true
	Ray.set_enabled(true)
