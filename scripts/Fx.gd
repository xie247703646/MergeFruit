extends Sprite

onready var tw = $Tween

var level:int = 0 setget _set_level,_get_level
var config:Dictionary

func _set_level(v)->void:
	level = v
	config = GameConfig.fruit_config[v]
	texture = config.fx_textures[0]

func _get_level()->int:
	return level

func play()->void:
	var fx_scale = config.fx_scale
	tw.interpolate_property(self,"scale",Vector2.ZERO,Vector2(fx_scale,fx_scale),1,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	tw.interpolate_property(self,"self_modulate:a",1,0,1,Tween.TRANS_LINEAR,Tween.EASE_IN,0.5)
	tw.interpolate_deferred_callback(self,1.5,"queue_free")
	tw.start()
