extends Node2D

@onready var label: Label = $label

func set_text(text):
	label.text = text
