extends Activator

func check_states() -> bool:
	for state in _activator_states:
		if not state:
			return false
	return true
