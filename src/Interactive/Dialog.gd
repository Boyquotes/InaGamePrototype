tool
extends Interactive

export(String, "TimelineDropdown") var timeline: String

func _ready() -> void:
	connect("player_interacted", self, "show_dialog")


func _get_configuration_warning() -> String:
	return "Select timeline" if not timeline else ""


func show_dialog() -> void:
	if not get_tree().paused:
		return
	var gdscript_dialog = Dialogic.start(timeline)
	
	gdscript_dialog.pause_mode = Node.PAUSE_MODE_PROCESS
	
	get_tree().paused = true
	gdscript_dialog.connect("timeline_end", self, "_on_timeline_end")
	add_child(gdscript_dialog)


func _on_timeline_end(timeline_name) -> void:
	get_tree().paused = false
