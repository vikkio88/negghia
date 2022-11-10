extends RigidBody2D

@onready var damage_indicator = preload("res://scenes/hud/floating_text.tscn")

@onready var body : CollisionShape2D = $body
@onready var head: CollisionShape2D = $head

const HEADSHOT_THRESHOLD: float = 23.0
const BODYSHOT_THRESHOLD: float = 60.0


func hit(point: Vector2) -> void:
	var head_d = head.global_position.distance_to(point)
	var body_d = body.global_position.distance_to(point)
	var type = "body shot"
	if head_d < HEADSHOT_THRESHOLD or head_d < body_d:
		type = "Headshot!"
	var t = damage_indicator.instantiate()
	$placeholder.add_child(t)
	t.set_text(type)
	var tween = create_tween()
	tween.tween_property(t, "position", Vector2(t.position.x,t.position.y - 40), .7)
	tween.tween_property(t, "text", "", 0.1)
	tween.tween_callback(func (): t.queue_free())
	
	
	
	
