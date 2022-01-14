extends Area

var activated = false

export(String, MULTILINE) var text = ""

onready var sfx = $SFX

func _on_PopupTrigger_body_entered(_body: Node) -> void:
	if activated or get_tree().paused:
		return
	
	get_tree().paused = true
	activated = true
	sfx.play()
	
	var gdscript_dialog = Dialogic.start('')
	gdscript_dialog.pause_mode = Node.PAUSE_MODE_PROCESS
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	gdscript_dialog.connect("timeline_end", self, "_on_timeline_end")
	gdscript_dialog.set_dialog_script( {
		"events": [
			{ "event_id":"dialogic_001", "text": text },
			{ "event_id": "dialogic_022", "transition_duration": 0.2}
		 ]
	})
	add_child(gdscript_dialog)


func _on_timeline_end(_timeline_name) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
