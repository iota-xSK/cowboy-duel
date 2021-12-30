extends KinematicBody2D

var velocity = Vector2(0, 0)

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	if get_slide_count() > 0:
		queue_free()
	
	#if get_slide_count() > 0:
		#for i in get_slide_count():
		#	var collision = get_slide_collision(i)
		#	var collider = collision.collider
			
		#	if collider.has_method("get_hit"):
		#		collider.get_hit()
		#		print(collider, " got hit")
		#	queue_free()
