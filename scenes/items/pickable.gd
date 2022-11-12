extends Node2D

@onready var Sprite = $sprite


func _on_playerdetector_body_entered(body: Node2D) -> void:
	print("player enter")
	EventsBus.emit_signal("interactable_on", "Rifle", "Pickup", func(): queue_free())


func _on_playerdetector_body_exited(body: Node2D) -> void:
	EventsBus.emit_signal("interactable_off")
