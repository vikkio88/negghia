class_name Enums

enum Weapons { Rifle, Pistol, AR }

static func weapon_to_string(type: Weapons)-> String:
	match type:
		Weapons.Rifle:
			return "Rifle"
		Weapons.Pistol:
			return "Pistol"
		Weapons.AR:
			return "AR"
	return "Not a Gun"
