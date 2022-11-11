extends Node2D

# Load the custom images for the mouse cursor.
@onready var arrow = preload("res://assets/cross.png")


func _ready() -> void:
	Input.set_custom_mouse_cursor(arrow,Input.CURSOR_ARROW,Vector2(15,15))
