class_name Player
extends KinematicBody2D

export var speed := 250.0
export var drag := 4.0

var _velocity := Vector2.ZERO
var random_generator = RandomNumberGenerator.new()
var alive = true
var tween_delay = 1.25
var current_hull_points = 0
var moves = 0
var player = null
var stats = null
var selected = false
signal ship_done_moving

onready var _weapon := get_node_or_null("Weapon")
onready var moving = false
onready var _sprite := $Sprite
onready var _animation_player := $AnimationPlayer

onready var _flame_main := $Sprite/FlameMain
onready var _flame_left := $Sprite/FlameLeft
onready var _flame_right := $Sprite/FlameRight

func _ready():
	random_generator.randomize()
	set_process_input(true) 
	##This may or may not be required for inputs to work.
	# Create a timer node
	var timer = Timer.new()
	add_child(timer)

	# Set the timer's properties
	timer.wait_time = 2.0 # 5 second delay
	timer.one_shot = true # run only once

	# Connect the timer to a function
	timer.connect("timeout", self, "move_forward")

	# Start the timer
	timer.start()

func move_forward():
	if(moving==false):
		moving=true
		var tempRotation = $Sprite.rotation-90
		var speed_x = speed * cos (tempRotation)
		var speed_y = speed * sin (tempRotation)
		var tween = get_node("MovementTween")
		tween.interpolate_property(self, "position",
				Vector2(position.x, position.y), Vector2(position.x + speed_x, position.y+speed_y), tween_delay,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		#transition.to(self.group, {time = 250,x = currentX + speed_x,y=currentY+speed_y})
	else:
		pass;
		#print("Ah ah ah.....still moving.."+str((randi()%12+0)))

func turn_right():
	if(moving==false):
		moving=true
		var turn_speed = -30
		var tween = get_node("MovementTween")
		tween.interpolate_property(self, "rotation_degrees",
				self.rotation_degrees, self.rotation_degrees - turn_speed, tween_delay,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()

func turn_left():
	if(moving==false):
		moving=true
		var turn_speed = 30
		var tween = get_node("MovementTween")
		tween.interpolate_property(self, "rotation_degrees",
				self.rotation_degrees, self.rotation_degrees - turn_speed, tween_delay,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()

		
func _physics_process(_delta: float) -> void:
	var direction := Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")).normalized()

	var desired_velocity := direction * speed
	var steering := desired_velocity - _velocity
	_velocity += steering / drag
	_velocity = _velocity.clamped(speed)

	_velocity = move_and_slide(_velocity, Vector2.UP, false, 4, PI / 4, false)

	_sprite.rotation = _velocity.angle() + PI / 2
	if _weapon:
		_weapon.rotation = _sprite.rotation

	# Updating flames
	var speed_rate := _velocity.length() / speed

	_flame_main.scale = Vector2.ONE * speed_rate
	_flame_left.scale = Vector2.ONE * speed_rate * 0.35
	_flame_right.scale = Vector2.ONE * speed_rate * 0.35


func take_damage() -> void:
	start_blink(false)


func start_blink(loop := false) -> void:
	_animation_player.get_animation("blink").set_loop(loop)
	_animation_player.play("blink")


func stop_blink():
	_animation_player.stop()
	_animation_player.seek(0, true)


func change_weapon(new_weapon: Node2D) -> void:
	if _weapon:
		_weapon.queue_free()
	_weapon = new_weapon
	add_child(_weapon)
