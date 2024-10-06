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

var present = null
@export var present_strength = 100.0
@export var present_max = 6000.0

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
		
	# handle the present after everything else!!
	handle_present(delta)

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

func handle_present(delta):
	if !is_instance_valid(present):
		return
		
	# Get the direction from the body to the attractor
	var direction = global_position - present.global_position
	var distance = direction.length()

	# Normalize the direction vector
	direction = direction.normalized()

	# Calculate gravity force based on the distance (stronger the farther away)
	var present_magnitude = present_strength * max(distance * distance, 1000)

	# Apply the custom gravity by setting the body's gravity scale in the right direction
	present.linear_velocity = (direction * present_magnitude).limit_length(present_max)
	


func _on_package_pickup_collider_area_entered(area: Area2D) -> void:
	print("IT WAS THE PRESENT")
	present = area.get_parent()
	present.collision_layer = 0b1000 # layer 5, not layer 1
	
	area.collision_layer = 0b100000 # layer 6 for area
	#TODO remove the present from the grapple hook collision area at this point
