extends "res://lessons_reference/05_inertia/05_runner_step_2.gd"

#ANCHOR:dust_ref
@onready var _dust: GPUParticles2D = %Dust
#END:dust_ref

#ANCHOR:physics_process
func _physics_process(delta: float) -> void:
#ANCHOR:physics_process_body
	#ANCHOR:direction_calculation
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#END:direction_calculation
	#ANCHOR:desired_velocity
	var desired_velocity := direction * max_speed
	#END:desired_velocity

	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()

	#ANCHOR:animation_condition
	if direction.length() > 0.0:
		#END:animation_condition
		_runner_visual.angle = rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)

		#ANCHOR:animation_run
		var current_speed_percent := velocity.length() / max_speed
		_runner_visual.animation_name = (
			RunnerVisual.Animations.WALK
			if current_speed_percent < 0.8
			else RunnerVisual.Animations.RUN
		)
		#END:animation_run
		_dust.emitting = true
	else:
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
		_dust.emitting = false
#END:physics_process_body
#END:physics_process
