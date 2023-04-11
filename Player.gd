extends KinematicBody2D

var speed = 100

func _physics_process(delta):
	var vel = Vector2(
		int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	)
	
	if Input.action_press("ui_select") and $RayCast2D.is_colliding():
		print("object recognized")
	
	move_and_slide(vel*speed)
