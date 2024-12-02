extends Control

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression

var expressions := {
	"happy": preload ("res://assets/emotion_happy.png"),
	"regular": preload ("res://assets/emotion_regular.png"),
	"sad": preload ("res://assets/emotion_sad.png"),
}

var current_item_index := 0

## An array of dictionaries. Each dictionary has two properties:
## - expression: a [code]Texture[/code] containing an expression
## - text: a [code]String[/code] containing the text the character says
var dialogue_items: Array[Dictionary] = [
	{
		"expression": expressions["regular"],
		"text": "I'm learning about Arrays..."
	},
	{
		"expression": expressions["sad"],
		"text": "... and it is a little bit complicated."
	},
	{
		"expression": expressions["happy"],
		"text": "Let's see if I got it right: an array is a list of values!",
	},
	{
		"expression": expressions["regular"],
		"text": "Did I get it right? Did I?",
	},
	{
		"expression": expressions["happy"],
		"text": "Hehe! Bye bye~!",
	},
]

func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)

## Draws the current text to the rich text element
func show_text() -> void:
	# We retrieve the current dictionary from the array and assign its
	# properties to the UI elements.
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item["text"]
	expression.texture = current_item["expression"]
	# We animate the text appearing letter by letter.
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
	var text_appearing_duration := 1.0
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)

	# This is where we play the audio. We randomize the audio playback's start
	# time to make it sound different every time.
	var sound_max_length := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_length
	audio_stream_player.play(sound_start_position)
	# We stop the audio when the text finishes appearing.
	tween.finished.connect(audio_stream_player.stop)


func advance() -> void:
	current_item_index += 1
	# If we reached the end of the dialogue, we quit the game. Otherwise, we
	# show the next dialogue line.
	if current_item_index == dialogue_items.size():
		get_tree().quit()
	else:
		show_text()
