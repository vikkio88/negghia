extends BaseWeapon


func _ready() -> void:
	super()
	Type = Enums.Weapons.AR
	Bullet_speed = 1900.0
	Base_damage = 25.0
	Recoil_Multiplier = 80.0
	Max_ammo = 30
	_ammo = 30
	Is_semi_auto = false
