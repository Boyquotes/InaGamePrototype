extends Area

signal state_changed(new_state)

export var initial_state: bool = false

onready var model = $Model

var switched: bool = false setget _on_switched

func _ready() -> void:
	model.material_override = model.material_override.duplicate(true)
	self.switched = initial_state


func _on_switched(new_val: bool) -> void:
	switched = new_val
	var test = model.material_override
	if new_val:
		(model.material_override as SpatialMaterial).albedo_color = Color.green
	else:
		(model.material_override as SpatialMaterial).albedo_color = Color.red



func _on_PressurePlate_body_entered(body: Node) -> void:
	if body is Player:
		self.switched = true
		emit_signal("state_changed", switched)


func _on_PressurePlate_body_exited(body: Node) -> void:
	if body is Player:
		self.switched = false
		emit_signal("state_changed", switched)
