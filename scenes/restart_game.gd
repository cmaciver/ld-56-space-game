extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../Score".text = "Score: " + str(Global.score)


func _on_button_up() -> void:
	Global.reset_score()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
