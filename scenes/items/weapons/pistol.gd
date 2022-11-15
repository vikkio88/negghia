extends BaseWeapon



func _ready() -> void:
	super()
	Type = Enums.Weapons.Pistol
	Bullet_speed = 800.0
	Recoil_Multiplier = 10.0
	Max_ammo = 7
	_ammo = 7
