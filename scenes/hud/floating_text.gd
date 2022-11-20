extends Node2D

@onready var label: Label = $label


func trigger(text: String, duration: float = .7, destroy: bool = true):
	# maybe there is a better way of doing this
	z_index = 100
	label.text = text
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 40, duration)
	tween.tween_property(self, "text", "", 0.1)
	if destroy:
		tween.tween_callback(func(): queue_free())
