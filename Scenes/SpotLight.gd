extends SpotLight

const UP = Vector3.UP

func _ready():
	hide()
	
func goal_scored(player_id: int):
	show()
	var scored_player = get_tree().root.find_node("Player%d" %player_id, true, false) as KinematicBody
	look_at(scored_player.translation, UP)
	
func reset():
	hide()
	
