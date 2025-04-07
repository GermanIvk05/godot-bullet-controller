class_name RegularBullet
extends BulletManager.Bullet

var velocity: Vector2 = Vector2.ZERO
var acceleration: Vector2 = Vector2.ZERO

func _init(position: Vector2, shape: Shape2D, space: RID) -> void:
	super(position)

	PhysicsServer2D.body_set_mode(body, PhysicsServer2D.BODY_MODE_KINEMATIC)
	PhysicsServer2D.body_add_shape(body, shape)
	PhysicsServer2D.body_set_collision_mask(body, 0)
	PhysicsServer2D.body_set_space(body, space)

func set_velocity(value: Vector2) -> RegularBullet:
	velocity = value
	return self

func set_acceleration(value: Vector2) -> RegularBullet:
	acceleration = value
	return self

func update(delta: float) -> void:
	# TODO: Implement the bullet movement logic here.

	velocity += acceleration * delta
	transform.origin += velocity * delta + 0.5 * acceleration * pow(delta, 2)

	PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform)

func debug(vectors: PackedVector2Array, colors: PackedColorArray) -> void:
	vectors.append_array([
		transform.origin, transform.origin + velocity,
		transform.origin, transform.origin + acceleration])
	colors.append_array([Color.RED, Color.GREEN])
	
