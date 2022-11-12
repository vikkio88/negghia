extends Node2D

@onready var Sprite = $sprite


func _on_playerdetector_body_entered(body: Node2D) -> void:
	print("player enter")


func _on_playerdetector_body_exited(body: Node2D) -> void:
	print("player exit")
