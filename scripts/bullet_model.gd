extends Resource
class_name BulletModel

@export var shape: Shape2D
@export var max_velocity := Vector2()
@export var acceleration := Vector2()

var bullets: Array[Bullet] = []
var space := RID()

func get_bullet_positions() -> PackedVector2Array:
	return bullets.map(func(b: Bullet): return b.position) as PackedVector2Array


func physics_update(delta: float) -> void:
	for bullet in bullets:
		bullet.velocity += acceleration * delta
		bullet.position += bullet.velocity * delta + 0.5 * acceleration * pow(delta, 2)
		bullet.update()


func spawn_bullet(position: Vector2, velocity: Vector2) -> Bullet:
	var bullet := Bullet.new(shape, space)
	bullet.position = position
	bullet.velocity = velocity
	# bullet.update()
	bullets.append(bullet)
	return bullet


func count() -> int:
	return bullets.size()


func clear() -> void:
	for bullet in bullets:
		bullet.destroy()
	bullets.clear()
