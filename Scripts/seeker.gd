extends CharacterBody2D

var movement_speed = 50.0

@export var target: Node2D = null
@export var stop_distance := 25.0

@onready var navigation_agent_2d_2: NavigationAgent2D = $NavigationAgent2D2


func _ready() -> void:
	call_deferred("seeker_setup")


func seeker_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d_2.target_position = target.global_position


func _physics_process(delta: float) -> void:
	if target:
		navigation_agent_2d_2.target_position = target.global_position

	var distance_to_target = global_position.distance_to(target.global_position)

	# Stop if close enough (your combat logic)
	if distance_to_target <= stop_distance:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# If stuck or no path, DON'T freeze completely
	if navigation_agent_2d_2.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var next_path_pos = navigation_agent_2d_2.get_next_path_position()
	var direction = (next_path_pos - global_position).normalized()

	velocity = direction * movement_speed
	move_and_slide()

	move_and_slide()
