extends RigidBody2D

@onready var ftext = preload("res://scenes/hud/floating_text.tscn")

@onready var body: CollisionShape2D = $body
@onready var head: CollisionShape2D = $head
@onready var dmg_placeholder: Node2D = $placeholder

const HEADSHOT_THRESHOLD: float = 23.0
const BODYSHOT_THRESHOLD: float = 60.0


func hit(point: Vector2) -> void:
	var head_d = head.global_position.distance_to(point)
	var body_d = body.global_position.distance_to(point)
	var type = "body shot"
	if head_d < HEADSHOT_THRESHOLD or head_d < body_d:
		type = "Headshot!"
	var t = ftext.instantiate()
	dmg_placeholder.add_child(t)
	t.trigger(type)
