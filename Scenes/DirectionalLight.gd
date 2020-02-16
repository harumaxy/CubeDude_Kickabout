extends DirectionalLight

func _ready():
	reset()

func goal_scored(player_id: int):
	$AnimationPlayer.play("Dim_Light")

func reset():
	light_energy = 1
