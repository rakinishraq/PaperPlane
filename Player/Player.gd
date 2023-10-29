extends KinematicBody2D

onready var anim = get_node("AnimationPlayer")

const JUMP_FORCE = 200
const GRAVITY = 10
const ANIM_SPEED = 0.05

var vspeed = 0
var dead = false
var rot = 0
var rot_up = false

func _ready():
	anim.play("idle", 1.0, 5.0)

func _physics_process(delta):
	if !get_parent().started:
		return
	
	vspeed += GRAVITY
	if Input.is_action_just_pressed("jump")  and !dead:
		anim.play("jump")
		vspeed = -JUMP_FORCE
		rot_up = true
	
	if Input.is_action_just_pressed("jump") and dead:
		get_tree().reload_current_scene()
	
	vspeed = move_and_slide(Vector2(0, vspeed)).y
	var coll = get_slide_collision(0)
	if coll != null or 0 > global_position.y and get_parent().started:
		dead = true
		$CollisionShape2D.disabled = true
		anim.play("dead")
	
	$Sprite.rotation = rot
	$CollisionShape2D.rotation = rot
	if rot_up:
		rot -= 10 * delta
		if rot < -0.7:
			rot_up = false
	elif get_parent().started and rot < 1:
		rot += 2*delta
