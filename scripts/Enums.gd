class_name Enums

enum Weapons { Rifle, Pistol, AR }

enum AIState { Idle, Patrol, Investigate, Chase, Attack }

enum NoiseLevel { Normal, Quiet, Loud }


static func weapon_to_string(type: Weapons) -> String:
	match type:
		Weapons.Rifle:
			return "Rifle"
		Weapons.Pistol:
			return "Pistol"
		Weapons.AR:
			return "AR"
	return "Not a Gun"


static func ai_state_to_string(state: AIState) -> String:
	match state:
		AIState.Idle:
			return "Idle"
		AIState.Patrol:
			return "Patrol"
		AIState.Investigate:
			return "Investigate"
		AIState.Chase:
			return "Chase"
		AIState.Attack:
			return "Attack"
		_:
			return "Unknown"
