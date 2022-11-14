extends CanvasLayer

@onready var interaction: Label = $interaction
@onready var interaction_key: Label = $interaction/action_key
var can_interact = false
var intereactable_callback: Callable = func (): pass




func _ready() -> void:
	EventsBus.connect("interactable_on", self._on_interactable)
	EventsBus.connect("interactable_off", self._off_interactable)

func _process(delta: float) -> void:
	if Input.is_action_just_released("f") and can_interact:
		interact()

func _on_interactable(item:String, action: String, callback : Callable):
	can_interact = true
	interaction.text = "%s %s" % [action, item]
	interaction_key.visible = true
	intereactable_callback = callback

func _off_interactable():
	interaction.text = ""
	interaction_key.visible = false
	can_interact = false
	intereactable_callback = func (): pass

func interact():
	if can_interact:
		intereactable_callback.call()
