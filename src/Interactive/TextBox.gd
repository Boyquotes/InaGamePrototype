extends Interactive

export(String, MULTILINE) var text

func _ready() -> void:
	connect("player_interacted", self, "show_dialog")

func show_dialog() -> void:
	if get_tree().paused:
		return
	
	var gdscript_dialog = Dialogic.start('')
	
	gdscript_dialog.pause_mode = Node.PAUSE_MODE_PROCESS
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	get_tree().paused = true
	gdscript_dialog.connect("timeline_end", self, "_on_timeline_end")
	gdscript_dialog.set_dialog_script( {
		"events": [
			{ "event_id":"dialogic_001", "text": text },
			{ "event_id": "dialogic_022", "transition_duration": 0.2}
		 ]
	})
	add_child(gdscript_dialog)


func _on_timeline_end(_timeline_name) -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
