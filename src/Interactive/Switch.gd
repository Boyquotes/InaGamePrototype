extends Interactive
class_name Switch

signal state_changed(new_state)

export var initial_state: bool = false

onready var model = $MeshInstance
onready var sfx = $SFX
onready var check_pos: Position3D = $CheckPos

var switched: bool setget _on_switched
var _switch_ready = false

func _ready() -> void:
	model.material_override = model.material_override.duplicate(true)
	self.switched = initial_state
	_switch_ready = true


func press_switch() -> void:
	_on_Switch_player_interacted()


func _on_switched(new_val: bool) -> void:
	if _switch_ready:
		sfx.play()
	switched = new_val
	if new_val:
		(model.material_override as SpatialMaterial).albedo_color = Color.green
	else:
		(model.material_override as SpatialMaterial).albedo_color = Color.red


func _on_Switch_player_interacted() -> void:
	self.switched = not self.switched
	emit_signal("state_changed", switched)
