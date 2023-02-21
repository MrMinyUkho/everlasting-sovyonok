extends Control


# Declare member variables here. Examples:
var cutscene = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$FilmLines.visible = cutscene
	$GameUI.visible = !cutscene
