extends Spatial

onready var Ball = get_tree().get_root().find_node("Ball", true, false) as RigidBody

var Player1_score = 0
var Player2_score = 0

export var maximum_score = 3

func update_score(player_id: int):
	if player_id == 1:
		Player1_score += 1
	else:
		Player2_score += 1
	$GUI.update_score(Player1_score, Player2_score)
	check_game_over()

func check_game_over():
	if Player1_score >= maximum_score or Player2_score >= maximum_score:
		$GUI.game_over()
		$Timer.stop()
		Music.stop()


func _ready():
	reset_pitch()
	
func retry():
	Player1_score = 0
	Player2_score = 0
	reset_pitch()
	Music.play()

func reset_pitch():
	var Ball_spawn = get_tree().root.find_node("BallSpawn", true, false) as Position3D
	Ball.translation = Ball_spawn.translation
	get_tree().call_group("Player", "reset")
	get_tree().call_group("Lighting", "reset")
	Ball.linear_velocity = Vector3.ZERO
	Ball.angular_velocity = Vector3.ZERO
	Ball.axis_lock_linear_x = false
	Ball.axis_lock_linear_y = false
	Ball.axis_lock_linear_z = false
	

func _on_GoalDetection_body_entered(body, goal_id):
	Ball.axis_lock_linear_x = true
	Ball.axis_lock_linear_y = true
	Ball.axis_lock_linear_z = true
	get_tree().call_group("Player", "set_can_move", false)
	get_tree().call_group("Player", "emit_particles", goal_id)
	get_tree().call_group("Lighting", "goal_scored", goal_id)
	print("you goaled %d th goal" % goal_id)
	$Timer.start()
	update_score(goal_id)
	if not $Airhorn.is_playing():
		$Airhorn.play()


func _on_Timer_timeout():
	reset_pitch()
