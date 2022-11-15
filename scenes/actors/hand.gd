extends Node2D

@onready var gun: Node2D = null

var ads_lerp = 10
var aim_default = Vector2(10, 44)
var aim_iron_sight = Vector2(50, -30)


func _ready() -> void:
	gun = $pistol
	EventsBus.connect("gun_pickup", self.pickup_gun)


func _process(delta: float) -> void:
	if Input.is_action_pressed("aim") and has_gun() and is_within_ads_range():
		position = position.lerp(aim_default + get_ads_position(), ads_lerp * delta)
	else:
		position = position.lerp(aim_default, ads_lerp * delta)

	if Input.is_action_just_released("g"):
		release_gun()


func get_ads_position():
	var multiplier = -1 if get_aimed_point().x < global_position.x else 1
	return Vector2(aim_iron_sight.x * multiplier, aim_iron_sight.y)


func is_within_ads_range() -> bool:
	return get_aimed_point().distance_to(global_position) > 150


func set_aim(aim: bool) -> void:
	if has_gun():
		gun.set_aim(aim)


func shoot() -> void:
	if has_gun():
		var recoil = gun.shoot()
		get_viewport().warp_mouse(get_viewport().get_mouse_position() + recoil)


func reload() -> void:
	if has_gun():
		gun.reload_start()


func check_ammo() -> int:
	if gun == null:
		return 0
	return gun._ammo


func max_ammo() -> int:
	if gun == null:
		return 0
	return gun.Max_ammo


func has_gun() -> bool:
	return gun != null


func get_aimed_point() -> Vector2:
	return get_global_mouse_position()


func pickup_gun(type: Enums.Weapons) -> void:
	var weapon = ItemFactory.make_weapon(type).instantiate()
	weapon.Equipped = true
	add_child(weapon)
	gun = weapon


func release_gun() -> void:
	if has_gun():
		EventsBus.emit_signal("gun_dropped", gun.Type, global_position)
		remove_child(gun)
		gun = null
