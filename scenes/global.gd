extends Node

# The score variable
var score
var music

func _ready():
	music = AudioStreamPlayer.new()
	add_child(music)
	music.stream = preload("res://assets/sound/space slingshot game.ogg")
	music.volume_db = 6.0
	music.play()

# Resets the score (if needed)
func reset_score() -> void:
	score = 0
