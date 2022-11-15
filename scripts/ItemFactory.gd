extends Node

@onready var rifle_scene = preload("res://scenes/items/weapons/rifle.tscn")
@onready var rifle_pickable_scene = preload("res://scenes/items/weapons/rifle_pickup.tscn")
@onready var pistol_scene = preload("res://scenes/items/weapons/pistol.tscn")
@onready var pistol_pickable_scene = preload("res://scenes/items/weapons/pistol_pickup.tscn")

func make_weapon(type: Enums.Weapons) -> Resource:
	match type:
		Enums.Weapons.Rifle:
			return rifle_scene
		Enums.Weapons.Pistol:
			return pistol_scene
		_:
			return rifle_scene

func make_pickable_weapon(type: Enums.Weapons) -> Resource:
	match type:
		Enums.Weapons.Rifle:
			return rifle_pickable_scene
		Enums.Weapons.Pistol:
			return pistol_pickable_scene
		_:
			return rifle_pickable_scene
