extends Node2D

@onready var gun: Node2D = null

func _ready() -> void:
	gun = $rifle
	

func shoot() -> void:
	if gun != null:
		gun.shoot()


