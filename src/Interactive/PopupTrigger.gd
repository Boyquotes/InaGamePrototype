extends Area

var activated = false

onready var accept_dialog = $AcceptDialog
onready var sfx = $SFX

func _on_PopupTrigger_body_entered(_body: Node) -> void:
	if not activated and not get_tree().paused:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		sfx.play()
		accept_dialog.popup_centered()
		activated = true


func _on_AcceptDialog_confirmed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_AcceptDialog_popup_hide() -> void:
	_on_AcceptDialog_confirmed()
