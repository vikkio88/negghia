extends CanvasLayer

@onready var message = $message




func _ready() -> void:
	EventsBus.connect("interactable_on", self._on_interactable)
	EventsBus.connect("interactable_off", self._off_interactable)

func _on_interactable(item:String, action: String, callback : Callable):
	message.text = "%s %s" % [action, item]

func _off_interactable():
	message.text = ""
