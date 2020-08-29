extends KinematicBody

var gravity = -9.8
var velocity = Vector3()
var camera

const SPEED = 3
const ACCEL = 3
const DE_ACCEL = 20

func _ready():
	camera = get_node("../Camera").get_global_transform()

func _physics_process(delta):
	var dir = Vector3()
	var is_moving = false
	
	if Input.is_action_pressed("ui_up"):
		dir += -camera.basis[2]
		is_moving = true
	elif Input.is_action_pressed("ui_down"):
		dir += camera.basis[2]
		is_moving = true
	elif Input.is_action_pressed("ui_left"):
		dir += -camera.basis[0]
		is_moving = true
	elif Input.is_action_pressed("ui_right"):
		dir += camera.basis[0]
		is_moving = true
		
	dir.y = 0
	dir = dir.normalized()
	
	velocity.y += delta * gravity
	
	var hv = velocity
	hv.y = 0
	
	var new_pos = dir * SPEED
	var accel = DE_ACCEL
	
	if dir.dot(hv) > 0:
		accel = ACCEL
		
	hv = hv.linear_interpolate(new_pos, accel * delta)
	
	velocity.x = hv.x
	velocity.z = hv.z
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	if is_moving:
		var angle = atan2(hv.x, hv.z)
		var rot = self.get_rotation()
		rot.y = angle
		self.set_rotation(rot)
	
	var speed = hv.length() / SPEED
	$HeroMesh/AnimationTreePlayer.blend2_node_set_amount("Idle_Run", speed)
