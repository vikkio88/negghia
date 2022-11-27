extends RigidBody2D

@onready var ftext = preload("res://scenes/hud/floating_text.tscn")

@onready var body: CollisionShape2D = $body
@onready var head: CollisionShape2D = $head
@onready var dmg_placeholder: Node2D = $placeholder
@onready var sprite: Sprite2D = $sprite

const HEADSHOT_THRESHOLD: float = 23.0
const BODYSHOT_THRESHOLD: float = 60.0


# ENEMY HITTING LOGIC
func hit(point: Vector2, base_dmg: float) -> void:
	var head_d = head.global_position.distance_to(point)
	var body_d = body.global_position.distance_to(point)
	var type = "body shot"
	var damage = base_dmg
	if head_d < HEADSHOT_THRESHOLD or head_d < body_d:
		type = "Headshot!"
		damage *= 2
	var t = ftext.instantiate()
	dmg_placeholder.add_child(t)
	t.trigger("%s - %d" % [type, damage])


func add_hole(hole: Node2D):
	sprite.add_child(hole)


# END OF ENEMY HITTING LOGIC


func show():
	sprite.modulate.a = 1


func hide():
	sprite.modulate.a = 0
