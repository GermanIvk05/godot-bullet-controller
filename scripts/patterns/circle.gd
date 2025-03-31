extends Node2D

const BULLET_COUNT = 700
var x = 60

func _physics_process(_delta: float) -> void:
		#for i in range(BULLET_COUNT):
	#	$ProjectileController.spawn_projectile(Vector2.ZERO, Vector2(65, 0))
	#	await get_tree().create_timer(0.3).timeout
	pass
		
	
func _on_timer_timeout() -> void:
	for i in range(BULLET_COUNT):
		var angle = 2 * PI / BULLET_COUNT * i
		$ProjectileManager.spawn_projectile(
			Vector2.ZERO, 
			Vector2(x, 0).rotated(angle), 
			Vector2(-20, 0).rotated(angle))
