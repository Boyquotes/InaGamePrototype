extends Activator

func check_states() -> bool:
	for state in _activator_states:
		print(state)
		if not state:
			return false
	return true
