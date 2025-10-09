class_name Bullet

var position := Vector2()
var velocity := Vector2()
var body: RID

func _init(shape: Shape2D, space: RID) -> void:
	body = PhysicsServer2D.body_create()
	
	PhysicsServer2D.body_set_mode(body, PhysicsServer2D.BODY_MODE_KINEMATIC)
	PhysicsServer2D.body_add_shape(body, shape)
	PhysicsServer2D.body_set_collision_mask(body, 0)
	PhysicsServer2D.body_set_space(body, space)


func destroy() -> void:
	PhysicsServer2D.free_rid(body)


func update() -> void:
	var transform2d := Transform2D()
	transform2d.origin = position
	PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)
