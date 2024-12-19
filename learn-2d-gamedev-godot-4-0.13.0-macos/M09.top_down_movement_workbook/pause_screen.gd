@tool

extends Control

@onready var blur_color_rect: ColorRect = %BlurColorRect
@onready var ui_panel_container: PanelContainer = %UIPanelContainer
@onready var resume_button: Button = %ResumeButton
@onready var quit_button: Button = %QuitButton

@export_range(0, 1.0) var menu_opened_amount := 0.0:
	set = set_menu_opened_amount

@export_range(0.1, 10.0, 0.01, "or_greater") var animation_duration := 2.3

var _is_currently_opening := false
var _tween: Tween

func set_menu_opened_amount(amount: float) -> void:
	menu_opened_amount = amount
	visible = amount > 0
	if ui_panel_container == null or blur_color_rect == null:
		return
	blur_color_rect.material.set_shader_parameter("blur_amount", lerp(0.0, 1.5, amount))
	blur_color_rect.material.set_shader_parameter("saturation", lerp(1.0, 0.3, amount))
	ui_panel_container.modulate.a = amount
	if not Engine.is_editor_hint():
		get_tree().paused = amount > 0.3

func toggle() -> void:
	_is_currently_opening = not _is_currently_opening

	var duration := animation_duration

	if _tween != null:
		if not _is_currently_opening:
			duration = _tween.get_total_elapsed_time()
		_tween.kill()

	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_trans(Tween.TRANS_QUART)

	var target_amount := 1.0 if _is_currently_opening else 0.0
	print(target_amount)
	_tween.tween_property(self, "menu_opened_amount", target_amount, duration)

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	menu_opened_amount = 0.0

	resume_button.pressed.connect(toggle)
	quit_button.pressed.connect(get_tree().quit)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle()
