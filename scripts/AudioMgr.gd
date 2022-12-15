extends Node

const audio_dic = {
	"fruit_merge":preload("res://scenes/AudioFruitMerge.tscn")
}

func play(audio_name:String)->void:
	var audio_scene:PackedScene = audio_dic[audio_name]
	var audio:AudioStreamPlayer = audio_scene.instance()
	audio.connect("finished",self,"_on_audio_finished",[audio],CONNECT_ONESHOT)
	add_child(audio)

func _on_audio_finished(audio:AudioStreamPlayer)->void:
	audio.queue_free()
