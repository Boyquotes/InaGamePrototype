extends State
class_name FollowerState

var follower: Follower


func _ready() -> void:
	yield(owner, "ready")
	follower = owner
