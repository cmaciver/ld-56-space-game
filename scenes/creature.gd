extends Node2D

@export var sprite : Texture 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	# it would be cool if this was the package but if it is the player that's ok!
	pass # Replace with function body.
