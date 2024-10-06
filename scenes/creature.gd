extends Node2D

@export var sprite : Texture 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sprite:
		$Sprite2D.texture = sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	# it would be cool if this was the package but if it is the player that's ok!
	# IT IS COOL I DID IT
	print("creature picked it up! RIGHT")
	Global.score += 1
	area.get_parent().queue_free() # free the present
	
	#$Label.font_color = Color("00FF00")
	$Label.scale = Vector2(5.0, 5.0)
	$Label.text = "Thanks!" # TODO add more phrases
	
	# TODO don't make it stay up forever
	
	
	
	#spawn a new package, and ig maybe a new creature
