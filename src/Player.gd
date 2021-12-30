extends KinematicBody2D

var speed = 200  # speed in pixels/sec
var velocity = Vector2.ZERO
var bullet = preload("res://scenes/bullet.tscn")
var pointin_v = Vector2(1, 0)

export var up_input = "up"
export var down_input = "down"
export var left_input = "left"
export var right_input = "right"
export var fire_input = "fire"

var walking = {
	"side": "walk_side",
	"back": "walk_back",
	"front": "walk_front",
	"angle_back": "walk_angle_back",
	"angle_front": "walk_angle_front"
}

var idle = {
	"side": "idle_side",
	"back": "idle_back",
	"front": "idle_front",
	"angle_back": "idle_angle_back",
	"angle_front": "idle_angle_front"
}

var shoot = {
	"side": "shoot_side",
	"back": "shoot_back",
	"front": "shoot_front",
	"angle_back": "shoot_angle_back",
	"angle_front": "shoot_angle_front"
}

var direction = "side"
var shooting = false

signal died

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed(right_input):
		velocity.x += 1
		
	if Input.is_action_pressed(left_input):
		velocity.x -= 1
		
	if Input.is_action_pressed(down_input):		
		velocity.y += 1
		
	if Input.is_action_pressed(up_input):
		velocity.y -= 1
		
	if Input.is_action_just_pressed(fire_input):
			shooting = true
			var new_bullet = bullet.instance()
			get_parent().call_deferred("add_child", new_bullet)
			new_bullet.call_deferred("set_global_position", global_position + pointin_v*25)
			new_bullet.velocity = pointin_v * 500

	velocity = velocity.normalized() * speed
	
	if velocity != Vector2(0, 0):
		pointin_v = velocity.normalized()

func handle_animations():
	if Input.is_action_pressed(right_input):
		$AnimatedSprite.flip_h = false
		if Input.is_action_pressed(up_input):
			direction = "angle_back"
		elif Input.is_action_pressed(down_input):
			direction = "angle_front"
		else:
			direction = "side"
		$AnimatedSprite.animation = walking[direction]
	elif Input.is_action_pressed(left_input):
		$AnimatedSprite.flip_h = true
		if Input.is_action_pressed(up_input):
			direction = "angle_back"
		elif Input.is_action_pressed(down_input):
			direction = "angle_front"
		else:
			direction = "side"
		$AnimatedSprite.animation = walking[direction]
	elif Input.is_action_pressed(up_input):
		$AnimatedSprite.flip_h = false
		direction = "back"
		$AnimatedSprite.animation = walking[direction]
	elif Input.is_action_pressed(down_input):
		$AnimatedSprite.flip_h = false
		direction = "front"
		$AnimatedSprite.animation = walking[direction]
	elif shooting:
		$AnimatedSprite.play(shoot[direction])
	else:
		$AnimatedSprite.animation = idle[direction]
func _physics_process(delta):
	get_input()
	handle_animations()
	velocity = move_and_collide(velocity * delta)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation in shoot.values():
		shooting = false

func get_hit():
	queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group("projectile"):
		emit_signal("died")
		body.queue_free()
		queue_free()
