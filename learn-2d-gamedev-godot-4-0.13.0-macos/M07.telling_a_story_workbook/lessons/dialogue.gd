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

var bodies := {
	"sophia": preload ("res://assets/sophia.png"),
	"pink": preload ("res://assets/pink.png")
}

var current_item_index := 0

## Data to display in the dialogue. Each dictionary in this array has three properties:
##
## - expression: a [code]Texture[/code] containing an expression
## - text: a [code]String[/code] containing the text the character says
## - character: a [code]Texture[/code] representing the character
var dialogue_items: Array[Dictionary] = [
	{
		"expression": expressions["regular"],
		"text": "I've been studying [wave]arrays and dictionaries[/wave] lately.",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["regular"],
		"text": "Oh, nice. How has it been going?",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["sad"],
		"text": "Well... it's a little [shake]complicated[/shake]!",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["sad"],
		"text": "Oh!",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["regular"],
		"text": "It sure takes time to click at first.",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["happy"],
		"text": "If you keep at it, eventually, you'll get the hang of it!",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["regular"],
		"text": "Mhhh... I see. I'll keep at it, then.",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["happy"],
		"text": "Thanks for the encouragement. Time to [tornado freq=3.0][rainbow val=1.0]LEARN!!![/rainbow][/tornado]",
		"character": bodies["sophia"],
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
	body.texture = current_item["character"]
	# We animate the text appearing letter by letter.
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
	var text_appearing_duration: float = current_item["text"].length() / 30.0
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)

	# This is where we play the audio. We randomize the audio playback's start
	# time to make it sound different every time.
	var sound_max_length := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_length
	audio_stream_player.play(sound_start_position)
	# We stop the audio when the text finishes appearing.
	tween.finished.connect(audio_stream_player.stop)
	slide_in()
	
	next_button.disabled = true
	tween.finished.connect(func() -> void:
		next_button.disabled = false
	)

func advance() -> void:
	current_item_index += 1
	# If we reached the end of the dialogue, we quit the game. Otherwise, we
	# show the next dialogue line.
	if current_item_index == dialogue_items.size():
		get_tree().quit()
	else:
		show_text()

func slide_in() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	
	body.position.x = 200.0
	tween.tween_property(body, "position:x", 0.0, 0.3)
	
	body.modulate.a = 0.0
	tween.parallel().tween_property(body, "modulate:a", 1.0, 0.2)
