extends CharacterBody2D


@export_range(0, 5000) var SPEED = 400.0
@export var MAX_SPEED = 2000.0 
var accel := Vector2(0, 0)
@export var falloff := 0.99

var grapple_path = preload("res://scenes/grapple.tscn")
var hooked = false
var grapple = null
@export var grapple_length = 1800
@export var grapple_strength = 1.0
@export var grapple_max = 5000.0

func _physics_process(delta: float) -> void:
	if is_on_floor():
		accel *= 0.8
	
		if Input.is_action_just_pressed("ui_accept"):
			print("jumpin")
			# TODO jump away from planet
	
	# momentum falloff somehow, implemented as "space friction"
	velocity *= falloff
	
	# sets up / removes grapple hook
	handle_grapple_hook()
	# does any grapple related physics
	var grapple_force = react_grapple() * delta
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	var player_velocity_change = input_dir * SPEED * delta
	
	var gravity_force = get_gravity() * delta
	
	# add force (accel) to velocity (speed), cap at MAX_SPEED
	velocity += player_velocity_change + gravity_force + grapple_force
	velocity.limit_length(MAX_SPEED)
	
	var collision_info = move_and_collide(velocity * delta)
	
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		velocity *= 0.5

# creates / destroys the grapple hook
func handle_grapple_hook():
	if Input.is_action_just_pressed("left_click"): # start grapple
		print("\nclicked")
		$RayCast2D.target_position = get_local_mouse_position().normalized() * grapple_length
		
	if Input.is_action_pressed("left_click"): # grapple while held
		var collided = $RayCast2D.get_collider()
		
		if is_instance_valid(collided) and not hooked:
			hooked = true
			grapple = grapple_path.instantiate()
			collided.add_child(grapple)
			
			grapple.global_position = $RayCast2D.get_collision_point()
			print("grappled!")
		
	if Input.is_action_just_released("left_click"): # end grapple
		if hooked:
			hooked = false
			grapple.queue_free()
			print("release")

# actually does grapple hook physics
func react_grapple():
	if not is_instance_valid(grapple):
		return Vector2()
		
	# Get the direction from the body to the attractor
	var direction = grapple.global_position - global_position
	var distance = direction.length()

	# Normalize the direction vector
	direction = direction.normalized()

	# Calculate gravity force based on the distance (stronger the farther away)
	var grapple_magnitude = grapple_strength * distance * distance

	# Apply the custom gravity by setting the body's gravity scale in the right direction
	return (direction * grapple_magnitude).limit_length(grapple_max)







		# Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	#move_and_slide()
