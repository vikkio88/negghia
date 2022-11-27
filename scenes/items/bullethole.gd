extends Node2D


func _ready() -> void:
	$anims.play("spawn", -1, 4)


func is_blood() -> void:
	$sprite.self_modulate = Color.RED
