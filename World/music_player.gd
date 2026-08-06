extends AudioStreamPlayer

var chosen_song : String = ""
var world_music : Array = ["res://Cozy Tunes v1.5.4/Cozy Tunes/Audio/ogg/Golden Gleam.ogg"]
var title_music : Array = ["res://Cozy Tunes v1.5.4/Cozy Tunes/Audio/ogg/Wanderer's Tale.ogg"]
var shop_music : Array = ["res://Cozy Tunes v1.5.4/Cozy Tunes/Audio/ogg/Pineapple Under The Sea.ogg", "res://Cozy Tunes v1.5.4/Cozy Tunes - The Classics/Audio/ogg/Tracks/Gymnopédie No.1.ogg", "res://Cozy Tunes v1.5.4/Cozy Tunes - The Classics/Audio/ogg/Tracks/Tales from the Vienna Woods.ogg"]

func world():
	var volume_tween = create_tween()
	volume_tween.tween_property(self, "volume_db", -30, 2)
	volume_tween.play()
	await volume_tween.finished
	chosen_song = world_music[randi() % world_music.size()]
	stream = load(chosen_song)
	print(chosen_song)
	play()
	var volume_down_tween = create_tween()
	volume_down_tween.tween_property(self, "volume_db", 0, 2)
	volume_down_tween.play()

func shop():
	var volume_tween = create_tween()
	volume_tween.tween_property(self, "volume_db", -30, 2)
	volume_tween.play()
	await volume_tween.finished
	chosen_song = shop_music[randi() % shop_music.size()]
	stream = load(chosen_song)
	print(chosen_song)
	play()
	var volume_down_tween = create_tween()
	volume_down_tween.tween_property(self, "volume_db", 0, 2)
	volume_down_tween.play()

func title():
	chosen_song = title_music[randi() % title_music.size()]
	stream = load(chosen_song)
	print(chosen_song)
	play()
