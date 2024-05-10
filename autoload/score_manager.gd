extends Node

var _score = 0
var _high_score =0

func get_score():
	return _score
	
func get_high_score():
	return _high_score

func set_score(value):
	_score = value
	print("Set Score: " + str(value))
	if _score > _high_score:
		_high_score = value
		print("High Score Updated: "  + str(_high_score))
	SignalManager.update_score.emit()

func increase_score(new_score):
	set_score(_score + new_score)
