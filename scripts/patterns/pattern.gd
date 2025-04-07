extends Node2D

@export var shape: Shape2D

const CLUSTER_COUNT = 5              # Number of clusters per wave
const BULLETS_PER_CLUSTER = 12       # Bullets in each cluster's spiral
const BULLET_LAYERS = 2             # Extra layers per bullet for added density

var cluster_timer: float = 0.0       # Drives the animation of clusters and spirals

func _ready() -> void:
	$Timer.start()

func _on_Timer_timeout() -> void:
	## Increment the timer to animate the clusters and spiral rotation
	cluster_timer += 1
	var viewport_size = get_viewport_rect().size
	
	# Spawn clusters evenly across the horizontal axis
	for c in range(CLUSTER_COUNT):
		# Compute the x position for the cluster
		var cluster_x = viewport_size.x * (c + 1) / (CLUSTER_COUNT + 1)
		# Compute the y position with a sine oscillation for dynamic vertical movement
		var cluster_y = viewport_size.y / 2 + sin(cluster_timer + c) * 150
		var cluster_pos = Vector2(cluster_x, cluster_y)
		
		# Determine a rotation offset that makes each cluster's spiral rotate over time
		var rotation_offset = cluster_timer + c
		
		# For each cluster, spawn a spiral burst of bullets
		for i in range(BULLETS_PER_CLUSTER):
			# Calculate the base angle for the bullet in the spiral
			var base_angle = TAU / BULLETS_PER_CLUSTER * i + rotation_offset
			# Spawn multiple layers for extra density
			for j in range(1, BULLET_LAYERS + 1):
				# Primary bullet from the spiral
				var bullet = RegularBullet.new(Vector2.RIGHT.rotated(base_angle), shape, get_world_2d().get_space())
				bullet.transform.translated(cluster_pos)
				var speed = 200 + 20 * j
				var accel = 20 + 5 * j
				bullet.set_velocity(Vector2(speed, 0).rotated(base_angle))
				bullet.set_acceleration(Vector2(accel, 0).rotated(base_angle))
				$BulletManager.add_bullet(bullet)
				
				# Extra cross-fire bullet in the opposite direction
				var opp_bullet = RegularBullet.new(Vector2.RIGHT.rotated(base_angle + PI), shape, get_world_2d().get_space())
				opp_bullet.transform.translated(cluster_pos)
				opp_bullet.set_velocity(Vector2(speed * 0.8, 0).rotated(base_angle + PI))
				opp_bullet.set_acceleration(Vector2(accel * 0.8, 0).rotated(base_angle + PI))
				$BulletManager.add_bullet(opp_bullet)
