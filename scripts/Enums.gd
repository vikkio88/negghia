class_name Enums

enum Weapons { Rifle, Pistol }

static func weapon_to_string(type: Weapons)-> String:
	match type:
		Weapons.Rifle:
			return "Rifle"
		Weapons.Pistol:
			return "Pistol"
	return "Not a Gun"
