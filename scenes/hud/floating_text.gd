extends Node2D

@onready var label: Label = $label

func trigger(text: String, duration: float = .7, destroy: bool = true):
	label.text = text
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 40, duration)
	tween.tween_property(self, "text", "", 0.1)
	if destroy:
		tween.tween_callback(func (): queue_free())
