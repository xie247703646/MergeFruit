extends CPUParticles2D

onready var timer:Timer = $Timer

var level:int = 0 setget _set_level,_get_level

func _set_level(v):
	level = v
	var config = GameConfig.fruit_config[v]
	texture = config.fx_textures[1]
	var par_scale = config.par_scale
	scale = Vector2(par_scale,par_scale)
	play()

func _get_level()->int:
	return level

func _ready() -> void:
	pass
#	emitting = true

func play()->void:
	emitting = true
	timer.start()


func _on_Timer_timeout() -> void:
	queue_free()
