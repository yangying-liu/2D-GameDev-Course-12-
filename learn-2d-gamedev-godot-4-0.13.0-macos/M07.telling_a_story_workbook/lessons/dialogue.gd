extends Control

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton

var charcter_name := "Sophia"

## An array of strings. Each string contains the text we want the character to 
##say.
var dialogue_items: Array[String] = [
	"I'm learning about Arrays...",
	"...and it is a little bit complicated.",
	"Let's see if I got it right: an array is a list of values!",
	"Did I get it right? Did I?",
	"Hehe! Bye bye~!",
]

## Holds the index of the currently displayed text
var current_item_index := 0

func show_text() -> void:
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item

func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)

func advance() -> void:
	current_item_index += 1
	if current_item_index == dialogue_items.size():
		get_tree().quit()
	else:
		show_text()
