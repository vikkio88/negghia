extends CanvasLayer

@onready var healthlbl: Label = $health
@onready var healthbar: ProgressBar = $healthbar
@onready var staminabar: ProgressBar = $staminabar

@onready var interaction: Label = $action_key/interaction
@onready var interaction_key: Label = $action_key
var can_interact = false
var intereactable_callback: Callable = func(): pass


func _ready() -> void:
	EventsBus.interactable_on.connect(self._on_interactable)
	EventsBus.interactable_off.connect(self._off_interactable)
	EventsBus.player_health_update.connect(self.health_update)


func _process(delta: float) -> void:
	if Input.is_action_just_released("f") and can_interact:
		interact()


func _on_interactable(item: String, action: String, callback: Callable):
	can_interact = true
	interaction.text = "%s %s" % [action, item]
	interaction_key.visible = true
	intereactable_callback = callback

func _off_interactable():
	interaction.text = ""
	interaction_key.visible = false
	can_interact = false
	intereactable_callback = func(): pass

func interact():
	if can_interact:
		intereactable_callback.call()

func health_update(health: int, max_health: int, stamina: int, max_stamina: int):
	healthlbl.text = "%d / %d - %d / %d " % [health, max_health, stamina, max_stamina]
	healthbar.max_value = max_health
	healthbar.value = health
	staminabar.max_value = max_stamina
	staminabar.value = stamina
