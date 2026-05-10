extends Node2D
class_name BulletModel

signal bullets_updated(positions: PackedVector2Array)

@export var shape: Shape2D
@export var max_velocity := 0.0
@export var acceleration := Vector2()

var bullets: Array[Bullet] = []
var space := RID()

func _ready() -> void:
	space = get_world_2d().get_space()


func _physics_process(delta: float) -> void:
	var viewport_rect := get_viewport_rect()
	var positions := PackedVector2Array()
	positions.resize(bullets.size())
	
	var i := 0
	while i < bullets.size():
		var bullet := bullets[i]
		_update_bullet(bullet, delta)
		
		if viewport_rect.has_point(bullet.position):
			positions.set(i, bullet.position)
			i += 1
		else:
			despawn_bullet(bullet)
	positions.resize(i)
	bullets_updated.emit(positions)


func _update_bullet(bullet: Bullet, delta: float) -> void:
	bullet.velocity += acceleration * delta
	bullet.velocity = bullet.velocity.limit_length(max_velocity)
	bullet.position += bullet.velocity * delta
	bullet.update()


func spawn_bullet(location: Vector2, velocity: Vector2) -> Bullet:
	var bullet := Bullet.new(shape, space)
	bullet.position = location
	bullet.velocity = velocity
	bullets.append(bullet)
	return bullet


func despawn_bullet(bullet: Bullet) -> void:
	bullet.destroy()
	var idx := bullets.find(bullet)
	bullets[idx] = bullets[-1]
	bullets.pop_back()


func _exit_tree() -> void:
	for bullet in bullets:
		bullet.destroy()
	bullets.clear()
