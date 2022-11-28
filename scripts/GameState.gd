extends Node

var is_game_started = false
var is_game_over = false


enum Stats { Kills, Hits, Headshots, Shots }
signal stat_update(type:Stats, quantity: int)

var kills:int = 0
var hits:int = 0
var headshots: int = 0
var shots: int = 0

func _ready() -> void:
	stat_update.connect(self.update_stats)

func get_stats() -> Dictionary:
	return {
		Stats.Kills: kills,
		Stats.Hits: hits,
		Stats.Headshots: headshots,
		Stats.Shots: shots
	}

func reset():
	kills = 0
	hits = 0
	headshots = 0
	shots = 0

func update_stats(stat: Stats, quantity: int = 1):
	match stat:
		Stats.Kills:
			kills += quantity
		Stats.Hits:
			hits += quantity
		Stats.Headshots:
			headshots += quantity
		Stats.Shots:
			shots += quantity
