extends Node2D

var started = false
var score = 0
var PIPE_ARRAY = []
const PIPE_GAP = Vector2(72, 60)

func _ready():
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	
	var PIPES = load("res://World/Pipes.tscn")
	for i in range(3):
		PIPE_ARRAY.append(PIPES.instance())
		add_child(PIPE_ARRAY[i])
		for pipe in PIPE_ARRAY[i].get_children():
			pipe.position.y = pipe.scale.y * PIPE_GAP.y/2
		PIPE_ARRAY[i].position = Vector2(
			i * PIPE_GAP.x + 144 + 16,
			RNG.randi_range(96, 160)
		)

func _physics_process(delta):
	if !$Player.dead:
		$Background.position.x -= delta
		if $Background.position.x <= -256:
			$Background.position.x = 0
		$Floor/Sprite.region_rect.position.x += delta * 50

	
	if !started:
		started = Input.is_action_just_pressed("jump")
		return
	

	$Title.modulate.a -= delta
	for pipes in PIPE_ARRAY:
		if !$Player.dead:
			pipes.position.x -= delta * 50
		if pipes.position.x <= -13:
			pipes.position.x += 144 + PIPE_GAP.x
			pipes.can_score = true
		if abs(pipes.position.x - $Player.position.x) < 10:
			if pipes.can_score:
				score += 1
			pipes.can_score = false
	$Node2D/Label.text = str(score)


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			Input.action_press("jump")
		else:
			Input.action_release("jump")
