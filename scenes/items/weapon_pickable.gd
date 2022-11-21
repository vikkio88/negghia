extends Node2D
class_name BaseWeaponPickable

@onready var Sprite = $sprite
@export var type: Enums.Weapons
@export var ammo_left: int = 0

const DROP_LERP: int = 10
const DROP_RANGE: int = 200

var _dropping: bool = false
var _to_pos: Vector2 = Vector2.ZERO


func init(position: Vector2, dropped: bool = false, ammo_left: int = 0) -> void:
	_dropping = dropped
	ammo_left = ammo_left
	global_position = position
	if dropped:
		_to_pos = (
			position
			+ Vector2(
				randi_range(DROP_RANGE / 2, DROP_RANGE), randi_range(DROP_RANGE / 2, DROP_RANGE)
			)
		)


func _physics_process(delta):
	if _dropping:
		position = position.lerp(_to_pos, DROP_LERP * delta)

	if position.distance_to(_to_pos) <= 3:
		_dropping = false

func pick_up() -> void:
	if _dropping:
		return
	EventsBus.emit_signal("gun_pickup", type, ammo_left)
	queue_free()


func _on_playerdetector_area_entered(area: Area2D) -> void:
	if area.is_in_group("interactable") and not _dropping:
		(
			EventsBus
			. emit_signal("interactable_on", Enums.weapon_to_string(type), "Pickup", self.pick_up)
		)
		


func _on_playerdetector_area_exited(area: Area2D) -> void:
	if area.is_in_group("interactable") and not _dropping:
		EventsBus.emit_signal("interactable_off")
