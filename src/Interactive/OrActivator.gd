extends Activator

func check_states() -> bool:
	for state in _activator_states:
		if state:
			return true
	return false
