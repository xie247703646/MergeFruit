extends Node2D

onready var fruit_pre:PackedScene = preload("res://scenes/Fruit.tscn")
onready var fx_pre:PackedScene = preload("res://scenes/Fx.tscn")
onready var particle_pre:PackedScene = preload("res://scenes/FruitMergeParticle.tscn")


onready var ui_root:CanvasLayer = $UIRoot
onready var dead_line:Node2D = $DeadLine
onready var spawn_pos:Position2D = $SpawnPos
onready var spawn_fruit:Sprite = $SpawnFruit
onready var audio_spawn:AudioStreamPlayer = $SpawnFruit/AudioSpawn
onready var fruit_container:Node2D = $FruitContainer
onready var fx_container:Node2D = $FXContainer
onready var merge_fruit_container:Node2D = $MergeFruitContainer
onready var score_label:Label = $ScoreLabel
onready var scroll_timer:Timer = $ScoreLabel/ScrollTimer
onready var game_state_check_timer:Timer = $GameStateCheckTimer
onready var fruit_explode_timer:Timer = $FruitExplodeTimer

var move_fruit_tween:SceneTreeTween
var fruit_create_tween:SceneTreeTween

var fruit_level:int = 0
var fruit_max_level:int = 0
var max_merge_level:int = 4

var show_score:int = 0 setget _set_show_score,_get_show_score
func _set_show_score(v)->void:
	show_score = v
	score_label.text = String(show_score)
func _get_show_score()->int:
	return show_score

var cur_score:int = 0 setget _set_cur_score,_get_cur_score
func _set_cur_score(v)->void:
	cur_score = v
	if scroll_timer.is_stopped():
		scroll_timer.start()
func _get_cur_score()->int:
	return cur_score

var can_move:bool = false
var need_fall:bool = false
var has_pressed:bool = false
var is_gameover:bool = false

func _ready() -> void:
	randomize()
	UIMgr.set_ui_root(ui_root)
	create_spawn_fruit(rand_fruit_level(),false,false)
	SignalMgr.connect("fruit_merged",self,"_on_fruit_merged")
	SignalMgr.connect("create_fruit",self,"_on_create_fruit")
	dead_line.visible = false

func _physics_process(delta: float) -> void:
	if is_gameover: return
	if fruit_create_tween.is_running(): return
	if can_move: update_spawn_fruit()

func update_spawn_fruit()->void:
	var fruit_width = spawn_fruit.get_rect().size.x
	var mouse_pos = get_global_mouse_position()
	spawn_fruit.global_position.x = clamp(mouse_pos.x,fruit_width / 2,get_viewport_rect().size.x - fruit_width / 2)

func tween_move_spawn_fruit()->void:
	move_fruit_tween = get_tree().create_tween()
	var fruit_width = spawn_fruit.get_rect().size.x
	var mouse_pos = get_global_mouse_position()
	var target_pos = clamp(mouse_pos.x,fruit_width / 2,get_viewport_rect().size.x - fruit_width / 2)
	move_fruit_tween.tween_property(spawn_fruit,"global_position:x",target_pos,0.1)
	move_fruit_tween.tween_callback(self,"_on_tween_completed")

func _on_tween_completed()->void:
	move_fruit_tween = null
	if need_fall:
		need_fall = false
		spawn_fruit.visible = false
		create_fruit(fruit_level,spawn_fruit.global_position,true)
	else:
		can_move = true

func create_spawn_fruit(level:int,play_sound:bool = true,delay:bool = true)->void:
	fruit_level = level
	if delay:
		yield(get_tree().create_timer(0.5),"timeout")
	spawn_fruit.visible = true
	spawn_fruit.texture = GameConfig.fruit_config[level]["texture"]
	spawn_fruit.global_position = spawn_pos.global_position
	spawn_fruit.scale = Vector2.ZERO
	fruit_create_tween = spawn_fruit.create_tween()
	fruit_create_tween.set_trans(Tween.TRANS_ELASTIC)
	fruit_create_tween.set_ease(Tween.EASE_OUT)
	fruit_create_tween.tween_property(spawn_fruit,"scale",Vector2.ONE,0.5)
	fruit_create_tween.play()
	if play_sound: audio_spawn.play()

func create_merge_fruit(level:int,global_pos:Vector2,target_pos:Vector2)->void:
	var merge_fruit:Sprite = Sprite.new()
	var fruit_texture = GameConfig.fruit_config[level]["texture"]
	merge_fruit.texture = fruit_texture
	merge_fruit.global_position = global_pos
	merge_fruit_container.add_child(merge_fruit)
	var fruit_tween = merge_fruit.create_tween()
	fruit_tween.tween_property(merge_fruit,"global_position",target_pos,0.1)
	fruit_tween.tween_callback(merge_fruit,"queue_free")

func create_fruit(level:int,global_pos:Vector2,is_new:bool)->void:
	var fruit = fruit_pre.instance()
	fruit.global_position = global_pos
	fruit.is_new = is_new
	fruit_container.call_deferred("add_child",fruit)
	fruit.set_deferred("level",level)

func _input(event: InputEvent) -> void:
	if is_gameover: return
	if not spawn_fruit.visible or fruit_create_tween.is_running(): return
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			has_pressed = true
			var offset = abs(spawn_fruit.global_position.x - get_global_mouse_position().x)
			can_move = offset <= 20
			if can_move: update_spawn_fruit()
			else: tween_move_spawn_fruit()
		else:
			if not has_pressed: return
			has_pressed = false
			can_move = false
			if move_fruit_tween:
				need_fall = true
			else:
				spawn_fruit.visible = false
				create_fruit(fruit_level,spawn_fruit.global_position,true)

func rand_create_fruit()->void:
	var min_x = 50
	var max_x = get_viewport_rect().size.x - 50
	var x = rand_range(min_x,max_x)
	var y = spawn_pos.global_position.y
	create_fruit(rand_fruit_level(),Vector2(x,y),true)

func rand_fruit_level()->int:
	return randi() % (fruit_max_level + 1)

func create_fx(level:int,global_pos:Vector2)->void:
	var fx = fx_pre.instance()
	fx_container.call_deferred("add_child",fx)
	fx.set_deferred("global_position",global_pos)
	fx.set_deferred("level",level)
	fx.call_deferred("play")

	var particle = particle_pre.instance()
	fx_container.call_deferred("add_child",particle)
	particle.set_deferred("global_position",global_pos)
	particle.set_deferred("level",level)
	particle.call_deferred("play")

func _on_fruit_merged(f1:Fruit,f2:Fruit)->void:
	if is_gameover: return
	if f1.is_queued_for_deletion() or f2.is_queued_for_deletion(): return
	var next_level = f1.level + 1
	if next_level > fruit_max_level and fruit_max_level < max_merge_level: fruit_max_level = next_level
	var target_pos = (f1.global_position + f2.global_position) / 2
	f1.queue_free()
	f2.queue_free()
	create_fruit(next_level,target_pos,false)
	create_fx(f1.level,f1.global_position)
	create_fx(f2.level,f2.global_position)
	create_merge_fruit(f1.level,f1.global_position,target_pos)
	create_merge_fruit(f2.level,f2.global_position,target_pos)
	set_deferred("cur_score",show_score + next_level)
	AudioMgr.play("fruit_merge")
	if next_level == 10: UIMgr.open_ui(UI.uiCelebrate)

func _is_higher_than_dead_line(fruit:Fruit)->bool:
	return fruit.global_position.y - fruit.radius < dead_line.global_position.y

func _on_create_fruit()->void:
	if is_gameover: return
	create_spawn_fruit(rand_fruit_level())

func _on_ScrollTimer_timeout() -> void:
	if show_score == cur_score: scroll_timer.stop()
	else: set_deferred("show_score",show_score + 1 if show_score < cur_score else show_score - 1)

func _on_RandCreateTimer_timeout() -> void:
	if is_gameover: return
	rand_create_fruit()

func _on_GameStateCheckTimer_timeout() -> void:
	var fruits:Array = fruit_container.get_children()
	dead_line.visible = false
	for fruit in fruits:
		if fruit.is_new: continue
		var offset = abs(dead_line.global_position.y - fruit.global_position.y + fruit.radius)
		if not dead_line.visible and offset < 100:
			dead_line.visible = true
		if _is_higher_than_dead_line(fruit):
			if fruit.danger_cnt >= 2:
				game_over()
#				get_tree().paused = true
				break
			fruit.danger_cnt += 1
		else:
			fruit.danger_cnt = 0

func game_over()->void:
	is_gameover = true
	if spawn_fruit.visible:
		spawn_fruit.visible = false
		create_fx(fruit_level,spawn_fruit.global_position)
	fruit_explode_timer.start()
	game_state_check_timer.stop()
	print("game over")

func game_restart()->void:
	print("game restart")
	get_tree().change_scene("res://scenes/Main.tscn")
#	fruit_level = 0
#	fruit_max_level = 0
#	set_deferred("cur_score",0)
#	set_deferred("show_score",0)
#	set_deferred("is_gameover",false)
#	call_deferred("create_spawn_fruit",rand_fruit_level())
#	game_state_check_timer.start()
#	fruit_explode_timer.stop()

func _on_FruitExplodeTimer_timeout() -> void:
	var fruits:Array = fruit_container.get_children()
	if fruits.size() > 0:
		var fruit:Fruit = fruits.pop_back()
		create_fx(fruit.level,fruit.global_position)
		fruit.queue_free()
		AudioMgr.play("fruit_merge")
	else:
		game_restart()
