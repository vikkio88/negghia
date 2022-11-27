extends Control

@onready var label: Label = $label
@onready var critical: Label = $critical


func _execute(duration: float):
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 70, duration)
	tween.tween_property(self, "text", "", 0.2)
	tween.tween_callback(func(): queue_free())


func trigger(text: String, duration: float = .8):
	label.text = text
	_execute(duration)


func trigger_critical(text: String, duration: float = .8):
	critical.text = text
	_execute(duration)
