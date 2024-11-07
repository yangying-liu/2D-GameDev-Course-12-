@tool
extends Node2D

const REQUIRED_PROPERTIES := ["velocity", "desired_velocity", "steering_vector", "steering_factor"]

const Vector2D = preload("vector_2d.gd")

@onready var desired_velocity: Vector2D = %DesiredVelocity
@onready var steering_velocity: Vector2D = %SteeringVelocity
@onready var velocity: Vector2D = %Velocity


func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)
	elif not parent_has_required_properties():
		push_warning("The parent node is missing the required properties: ", str(REQUIRED_PROPERTIES), "\nHiding and disabling the vectors.")
		set_process(false)
		hide()


func _get_configuration_warnings() -> PackedStringArray:
	if owner != self and get_parent() != null and not parent_has_required_properties():
		return ["The parent node does not have the properties required to make this visualization work. Did you instantiate this as a child of the ship? If so, make sure that there are no typos in the ship's member variables: %s" % [REQUIRED_PROPERTIES]]
	return [""]


func _process(delta: float) -> void:
	var ship: Node2D = get_parent()
	global_position = ship.global_position
	velocity.vector = ship.velocity / 3.0
	desired_velocity.vector = ship.desired_velocity / 3.0
	steering_velocity.vector = ship.steering_vector * 5.0 * ship.steering_factor * delta
	steering_velocity.position = velocity.vector


func parent_has_required_properties() -> bool:
	for current_property in REQUIRED_PROPERTIES:
		if not current_property in get_parent():
			return false
	return true
