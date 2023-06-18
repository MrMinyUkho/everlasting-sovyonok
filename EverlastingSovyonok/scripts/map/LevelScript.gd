extends Node2D

@onready var level  = get_node("./bus_stop_tilemap")
@onready var Glob   = get_node("/root/Global")

class SortByY:
	static func sort_ascending(a, b):
		if a.position.y < b.position.y:
			return true
		return false

func _process(delta):
		
	# Это для сортировки спрайтов по Y, для добавления глубины уровня
	var children = self.get_children()
	
	children.sort_custom(Callable(SortByY,"sort_ascending"))
	
	for i in range(len(children)):
		if children[i] != level:
			children[i].z_index = i - 4094
	
