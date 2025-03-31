class_name Projectile
extends Resource

@export var shape: Shape2D

@export_group("Linear", "linear_")
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var linear_velocity: Vector2
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var linear_acceleration: Vector2

@export_group("Angular", "angular_")
@export_custom(PROPERTY_HINT_NONE, "suffix:°/s") var angular_velocity: float
@export_custom(PROPERTY_HINT_NONE, "suffix:°/s") var angular_acceleration: float

var position := Vector2.ZERO
var body := RID()

## Updates the projectile's position
func update(delta: float) -> void:
	var transform2d := Transform2D()

	# Update the projectile's position based on its linear velocity and acceleration.
	position += linear_velocity * delta
	linear_velocity += linear_acceleration * delta

	transform2d.origin = position

	PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)
