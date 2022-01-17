extends Spatial
class_name Activator

signal state_changed(new_state)

export(Array, NodePath) var activators = []
export var stay_active = false

onready var model = $MeshInstance

var switched: bool setget _on_switched
var _activator_states: Array = []

func _ready() -> void:
	model.material_override = model.material_override.duplicate(true)
	for i in range(activators.size()):
		var aux_node = get_node(activators[i])
		aux_node.connect("state_changed", self, "_on_activator_state_changed", [i])
		_activator_states.append(aux_node.switched)
	
	self.switched = check_states()
	emit_signal("state_changed", switched)


func _on_activator_state_changed(new_state: bool, number_array: int) -> void:
	if stay_active and switched:
		return
	
	_activator_states[number_array] = new_state
	
	self.switched = check_states()
	emit_signal("state_changed", switched)


func check_states() -> bool:
	return false


func _on_switched(new_val: bool) -> void:
	switched = new_val
	if new_val:
		(model.material_override as SpatialMaterial).albedo_color = Color.green
	else:
		(model.material_override as SpatialMaterial).albedo_color = Color.red

