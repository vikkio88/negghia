extends Node

var _gates = {}

func get_gate_by_name(name: String) -> bool:
	return _gates[name] if _gates.has(name) else false

func dispose_gated_timer(name: String):
	if _gates.has(name):
		_gates.erase(name)

func gated_timer(name: String, time_sec: float, callback: Callable) -> void:
	if _gates.has(name) and _gates[name] == true:
		return
	
	_gates[name] = true
	timer(time_sec, func():
		callback.call()
		_gates[name] = false,
	)

func timer(time_sec:float,callback: Callable) -> void:
	get_tree().create_timer(time_sec).timeout.connect(callback)
