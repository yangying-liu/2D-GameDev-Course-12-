extends CharacterBody2D

@export var max_speed := 600.0
@export var acceleration := 1200.0
@export var deceleration := 1080.0

@onready var dust: GPUParticles2D = %Dust
@onready var runner_visual: RunnerVisual = %RunnerVisualPurple
@onready var hit_box: Area2D = %HitBox

func _ready() -> void:
	hit_box.body_entered.connect(func(body: Node) -> void:
		if body is Runner:
			get_tree().call_deferred("reload_current_scene")
	)

func _physics_process(delta: float) -> void:
	var direction := global_position.direction_to(get_global_player_position())
	var distance := global_position.distance_to(get_global_player_position())
	var speed := max_speed if distance > 100 else max_speed * distance / 100
	var desired_velocity := direction * speed

	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()

	if velocity.length() > 10.0:
		runner_visual.angle = rotate_toward(runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)

		var current_speed_percent := velocity.length() / max_speed
		runner_visual.animation_name = (
			RunnerVisual.Animations.WALK
			if current_speed_percent < 0.8
			else RunnerVisual.Animations.RUN
		)
		dust.emitting = true
	else:
		runner_visual.animation_name = RunnerVisual.Animations.IDLE
		dust.emitting = false

func get_global_player_position() -> Vector2:
	return get_tree().root.get_node("Game/Runner").global_position
