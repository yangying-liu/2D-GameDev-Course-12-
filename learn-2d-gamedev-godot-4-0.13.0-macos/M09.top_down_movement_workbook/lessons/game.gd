extends Node2D

@onready var finish_line: FinishLine = %FinishLine
@onready var count_down: CountDown = %CountDown
@onready var runner: Runner = %Runner
@onready var bouncer: CharacterBody2D = %Bouncer

func _ready() -> void:
	finish_line.body_entered.connect(func (body: Node) -> void:
		if body is not Runner:
			return
		var runner := body as Runner

		runner.set_physics_process(false)
		var destination_position := (
			finish_line.global_position
			+ Vector2(0, 64)
		)

		runner.walk_to(destination_position)
		runner.walked_to.connect(
			finish_line.pop_confettis
		)
	)

	finish_line.confettis_finished.connect(
		get_tree().reload_current_scene
	)
	
	count_down.start_counting()
	runner.set_physics_process(false)
	count_down.counting_finished.connect(
		func() -> void:
			runner.set_physics_process(true)
	)
	
	bouncer.set_physics_process(false)

	count_down.counting_finished.connect(
		func() -> void:
			bouncer.set_physics_process(true)
	)
