extends Control
class_name UIBase

var ui_name:String = ''

func on_open():
	pass

func on_close():
	pass

func close()->bool:
	return UIMgr.close_ui(ui_name)
