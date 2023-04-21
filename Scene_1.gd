extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	set_process_input(true) 
	##This may or may not be required for inputs to work.

func _input(event):
	if event is InputEventKey and event.is_action_released("KEY_J"):
		if event.scancode != KEY_ENTER:
			print(event.scancode)
			match event.scancode:
				"KEY_Z":
					print("1")
				"KEY_Y":
					print("2")

			#Do what you gotta do.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if $RayCast2D.is_colliding():
#		print($RayCast2D.get_collider().get_parent().name)
