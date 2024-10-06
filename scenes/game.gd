extends Node

@export var start_timer = 60.0 # in seconds
var timer

var gameplay = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reset_score()
	timer = start_timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	
	if gameplay and is_instance_valid($Player/Camera2D/Clock):
		$Player/Camera2D/Clock.text = convert_to_seconds(timer)
	
	if timer < 0:
		pass
		# TODO you lose
		gameplay = false
		#var scene = preload("res://scenes/game_over.tscn")
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func get_time():
	return convert_to_seconds(timer)
	
func convert_to_seconds(i):
	var minutes = floor(i / 60)  # Get the number of full minutes
	var seconds = int(i) % 60  # Get the remaining seconds
	var decimal = floor((i - int(i)) * 1000)
		
	return "%d:%02d.%03d" % [minutes, seconds, decimal]

# Increases the score by a given amount
func add_score(amount: int) -> void:
	Global.score += amount
	$Player/Camera2D/Score.text = Global.score
