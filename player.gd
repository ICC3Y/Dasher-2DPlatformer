extends CharacterBody2D

@export var speed := 130.0
@export var accel := 900.0
@export var friction := 1000.0
@export var jump_velocity := -300.0
@export var coyote_time := 0.1
@export var jump_buffer_time := 0.1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var coyote := 0.0
var buffer := 0.0

func _physics_process(delta: float) -> void:

		
	#coyote timer
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote -= delta
	else:
		coyote = coyote_time
	
	#jump
	if Input.is_action_just_pressed("jump"):
		buffer = jump_buffer_time
	buffer -= delta
	
	
	#jump buffer
	if buffer > 0.0 and coyote > 0.0:
		velocity.y = jump_velocity
		buffer = 0.0
		coyote = 0.0

	# variable jump height
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.5
		
	#move left and right
	var dir := Input.get_axis("move_left", "move_right")
	if dir != 0.0:
		velocity.x = move_toward(velocity.x, dir * speed, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		
	#animation
	if is_on_floor():
		if dir== 0: 
			animated_sprite_2d.play("Idle")
		else:
			animated_sprite_2d.play("Run")
	else: 
		animated_sprite_2d.play("Jump")
		
	# Flip Character
	if dir > 0:
		animated_sprite_2d.flip_h = false
	elif dir < 0:
		animated_sprite_2d.flip_h = true

	move_and_slide()
