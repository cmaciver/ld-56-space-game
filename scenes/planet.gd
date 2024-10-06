@tool
extends Node2D

@export var sprite : Texture 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sprite:
		$PlanetBody/Sprite2D.texture = sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
