extends KinematicBody

onready var animation = $AnimationPlayer
onready var scanner: Area = $Scanner
onready var scanner_collision = $Scanner/CollisionShape
onready var raycast: RayCast = $RayCast
onready var raycast_pos = $RayCastPos

export var gravity = -80

var velocity = Vector3.ZERO
var _snap = Vector3(0, 0.2, 0)

func _ready() -> void:
	raycast.set_as_toplevel(true)
	animation.queue("Summon")

func delete() -> void:
	animation.play("die")


func _physics_process(delta: float) -> void:
	velocity.y = velocity.y + gravity * delta
	if not is_on_floor():
		velocity.x = 0.0
		velocity.z = 0.0
		_snap = Vector3.ZERO
	else:
		_snap = Vector3(0, 0.2, 0)
	velocity = move_and_slide_with_snap(velocity, _snap, Vector3.UP, true)


func _on_Scanner_area_entered(area: Area) -> void:
	if area is Switch:
		animation.queue("Press")
		yield(animation,"animation_finished")
		
		raycast.global_transform.origin = raycast_pos.global_transform.origin
		raycast.cast_to = area.check_pos.global_transform.origin - raycast.global_transform.origin
		
		raycast.force_raycast_update()
		
		var colliding = raycast.is_colliding()
		var in_area = scanner.get_overlapping_areas().has(area)
		
		print(colliding, in_area)
		
		if (in_area and not colliding):
			area.press_switch()
