class_name Bullet
var transform: Transform2D
var body: RID

var velocity: Vector2 = Vector2.ZERO
var acceleration: Vector2 = Vector2.ZERO

func _init(position: Vector2, shape: Shape2D, space: RID) -> void:
	transform = Transform2D().translated(position)
	body = PhysicsServer2D.body_create()
	
	PhysicsServer2D.body_set_mode(body, PhysicsServer2D.BODY_MODE_KINEMATIC)
	PhysicsServer2D.body_add_shape(body, shape)
	PhysicsServer2D.body_set_collision_mask(body, 0)
	PhysicsServer2D.body_set_space(body, space)


func destroy() -> void:
	PhysicsServer2D.free_rid(body)


func set_velocity(value: Vector2) -> Bullet:
	velocity = value
	return self


func set_acceleration(value: Vector2) -> Bullet:
	acceleration = value
	return self


func update(delta: float) -> void:
	velocity += acceleration * delta
	transform.origin += velocity * delta + 0.5 * acceleration * pow(delta, 2)
	
	PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform)
