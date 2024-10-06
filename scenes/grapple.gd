extends Area2D

@export var gravity_strength = 1.0
var player_ref = null

func set_player(p):
	player_ref = p
	
func get_line():
	return $Line2D

func apply_custom_gravity(body: RigidBody2D):
	# Get the direction from the body to the attractor
	var direction = position - body.position
	var distance = direction.length()
	
	# Normalize the direction vector
	direction = direction.normalized()
	
	# Calculate gravity force based on the distance (stronger the farther away)
	var gravity_magnitude = gravity_strength * (distance * distance)
	
	# Apply the custom gravity by setting the body's gravity scale in the right direction
	body.apply_force(direction * gravity_magnitude, Vector2())

func _physics_process(delta: float):
	# Apply custom gravity to the player
	apply_custom_gravity(player_ref)
