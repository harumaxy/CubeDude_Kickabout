extends KinematicBody

var motion = Vector3.ZERO
var can_move = true

func set_can_move(b: bool):
	self.can_move = b

export var speed = 5
export var max_speed = 50

const UP = Vector3.UP
const GRAVITY = -5
const EPSILON = 0.00001

func _ready():
	add_to_group("Player")

func _process(delta):
	face_foward()

func _physics_process(delta):
	if can_move:
		move(delta)
		animate()
	fall()

func reset():
	var my_spawn = get_tree().root.find_node("Player%sSpawn" %str(player_id), true, false) as Position3D
	self.transform = my_spawn.transform
	set_can_move(true)


func face_foward():
	if not motion.x == 0 or not motion.z == 0:
		look_at(Vector3(-motion.x, 0, -motion.z) * 2, UP)

func animate():
	# フリッカーを防ぐため、限りなく0に近いイプシロンと比較
	if motion.length() > EPSILON:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Arms Cross Walk")
	else:
		$AnimationPlayer.stop()


export var player_id = 1
	
func move(delta: float):
	if Input.is_action_pressed("up_%s" %player_id) and not Input.is_action_pressed("down_%s" %player_id):
		motion.z -= 1
	elif not Input.is_action_pressed("up_%s" %player_id) and  Input.is_action_pressed("down_%s" %player_id):
		motion.z += 1
	else:
		motion.z = 0	
	motion.z = clamp(motion.z, -max_speed, max_speed)

	if Input.is_action_pressed("right_%s" %player_id) and not Input.is_action_pressed("left_%s" %player_id):
		motion.x += 1
	elif not Input.is_action_pressed("right_%s" %player_id) and Input.is_action_pressed("left_%s" %player_id):
		motion.x -= 1
	else:
		motion.x = 0
	motion.x = clamp(motion.x, -max_speed, max_speed)
	
	self.move_and_slide(motion.normalized() * speed, UP)
	
	
func fall():
	if is_on_floor():
		motion.y = 0
	else:
		motion.y += GRAVITY
		
func emit_particles(player_id: int):
	if self.player_id == player_id:
		$Particles.emitting = true
