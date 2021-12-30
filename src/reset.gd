extends Button


# Declare member variables here. Examples:
# var a = 2
var world = preload("res://scenes/world.tscn")
var world_instance = world.instance()
func _ready():
	get_parent().call_deferred("add_child", world_instance)

func _on_Button_pressed():
	world_instance.queue_free()
	world_instance = world.instance()
	get_parent().call_deferred("add_child", world_instance)
