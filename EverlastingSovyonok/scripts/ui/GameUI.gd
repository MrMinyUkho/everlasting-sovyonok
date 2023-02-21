extends Control


# Declare member variables here. Examples:
var cutscene = false

func _ready():
	pass # Replace with function body.

# warning-ignore:unused_argument
func _process(delta):
	$FilmLines.visible = cutscene
	$GameUI.visible = !cutscene
