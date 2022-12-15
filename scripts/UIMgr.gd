extends Node

var _dic_open_ui:Dictionary = {}

#ui根节点
var _ui_root:CanvasLayer setget set_ui_root,get_ui_root
func set_ui_root(v:CanvasLayer):
	if _ui_root:
		printerr('ui根节点已经存在!')
		return
	print('设置ui根节点')
	_ui_root = v

func get_ui_root():
	return _ui_root

func open_ui(ui_name:String)->UIBase:
	if !UI.path.has(ui_name):
		printerr('ui配置中没有%s'%[ui_name])
		return null
	var path = UI.path.get(ui_name)
	if not ResourceLoader.exists(path,"PackedScene"):
		printerr('不存在路径为%s的场景'%[path])
		return null
	if is_ui_open(ui_name):
		printerr('%s已经打开'%[ui_name])
		return null
	var ui_scene:PackedScene = load(path)
	if not ui_scene:
		printerr('%s不存在'%[ui_name])
		return null
	var ui_node:UIBase = ui_scene.instance()
	if not ui_node:
		printerr('%s实例化失败'%[ui_name])
		return null
	if not _ui_root:
		printerr('ui根节点为空')
		return null
	if not ui_node.has_method("on_open"):
		printerr('%s没有on_open方法'%[ui_name])
		return null
	_ui_root.add_child(ui_node)
	ui_node.on_open()
	print('打开%s'%[ui_name])
	ui_node.ui_name = ui_name
	_dic_open_ui[ui_name] = ui_node
	return ui_node

func close_ui(ui_name:String)->bool:
	if not is_ui_open(ui_name):
		printerr('%s暂未打开'%[ui_name])
		return false
	var ui_node:UIBase = _dic_open_ui.get(ui_name)
	if not ui_node.has_method("on_close"):
		printerr('%s没有on_close方法'%[ui_name])
		return false
	ui_node.on_close()
	ui_node.queue_free()
	_dic_open_ui.erase(ui_name)
	print('关闭%s'%[ui_name])
	return true

func is_ui_open(ui_name:String)->bool:
	return _dic_open_ui.has(ui_name)

func get_ui(ui_name:String)->UIBase:
	if not is_ui_open(ui_name):
		printerr('%s暂未打开'%[ui_name])
		return null
	return _dic_open_ui.get(ui_name)
