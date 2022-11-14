extends Node2D

@onready var Sprite = $sprite


func _on_playerdetector_body_entered(body: Node2D) -> void:
	print("player enter")
	EventsBus.emit_signal("interactable_on", "Rifle", "Pickup", self.pick_up)


func _on_playerdetector_body_exited(body: Node2D) -> void:
	EventsBus.emit_signal("interactable_off")


func pick_up() -> void:
	EventsBus.emit_signal("gun_pickup", "rifle")
	queue_free()
