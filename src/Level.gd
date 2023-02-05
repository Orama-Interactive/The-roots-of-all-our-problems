extends Node2D

var tree_tscn := preload("res://src/tree.tscn")
var forest_obstacles: Array[PackedScene] = [
		preload("res://src/Obstacles/Treetop_1.tscn"),
		preload("res://src/Obstacles/Treetop_2.tscn"),
	]
var forest_obstacles_2: Array[PackedScene] = [
		preload("res://src/Obstacles/Treetop_1.tscn"),
		preload("res://src/Obstacles/Treetop_2.tscn"),
		preload("res://src/Obstacles/Rock_1.tscn"),
		preload("res://src/Obstacles/Rock_2.tscn"),
		preload("res://src/Obstacles/Arrow.tscn"),
	]
var city_obstacles: Array[PackedScene] = [
		preload("res://src/Obstacles/Antenna_1.tscn"),
		preload("res://src/Obstacles/Antenna_2.tscn"),
		preload("res://src/Obstacles/Rock_1.tscn"),
		preload("res://src/Obstacles/Rock_2.tscn"),
	]
var war_obstacles: Array[PackedScene] = [
		preload("res://src/Obstacles/Treetrunk_1.tscn"),
		preload("res://src/Obstacles/Treetrunk_2.tscn"),
		preload("res://src/Obstacles/Treetrunk_3.tscn"),
		preload("res://src/Obstacles/Treetrunk_4.tscn"),
		preload("res://src/Obstacles/Rock_1.tscn"),
		preload("res://src/Obstacles/Rock_2.tscn"),
		preload("res://src/Obstacles/Arrow.tscn"),
	]
var checkpoints: Array[Checkpoint] = [
	Checkpoint.new(0, forest_obstacles,"", "The seed flew east, through a forest. (hold [space] to jump)", "[forest ambience]", preload("res://assets/audio/sounds/forest_ambience.wav"),),
	Checkpoint.new(1500, forest_obstacles, "", "Navigating its way through the forest, the seed had to avoid the tree tops"),
	Checkpoint.new(3000, forest_obstacles, "", "“This forest is way too dense” the seed thought. I won’t be able to root properly here, with so little sun."),
	Checkpoint.new(4500, forest_obstacles, "", "But then, the seed lost its train of thought to a cracking sound.", "[sound of a tree being chopped and sound of trees falling]"),
	Checkpoint.new(6000, forest_obstacles_2, "", "Why are the trees falling out of nowhere? Maybe that’s my chance to root!"),
	Checkpoint.new(7500, forest_obstacles_2, "", "But as the seed navigated further into the forest it realised that this place is far from safe.", "[sounds of rocks and arrows]"),
	Checkpoint.new(9000, forest_obstacles_2, "forest_fade_1", "The trees were falling one after the other. What could have caused such a catastrophe?"),
	Checkpoint.new(10500, forest_obstacles_2, "forest_fade_2", "I have to travel further, the seed thought and it gathered all of its strength and courage to go even further."),
	Checkpoint.new(12000, city_obstacles, "town_fade_in_1", "But things were getting even more weird the further it went. The forest lost its colours and the sound became louder and louder", "[sounds of a busy city]", preload("res://assets/audio/sounds/busy_city.wav")),
	Checkpoint.new(13500, city_obstacles, "town_fade_in_2", "“There’s barely any soil here, how will I find a place to root?” The seed thought as it traveled even further in that gray looking forest."),
	Checkpoint.new(15000, city_obstacles, "bomb", "And suddenly, a sound unlike any other.", "[bomb falling, exploding]"),
	Checkpoint.new(16500, war_obstacles, "", "And everything was calm again."),
	Checkpoint.new(18000, war_obstacles, "", "The forest was long gone."),
	Checkpoint.new(20000, war_obstacles, "", "But the poor seed had little strength, for it had used all of its energy looking for a better place to root."),
]
var current_checkpoint := 0
var max_distance := 21000
var narrations: Array[AudioStream] = [
	preload("res://assets/audio/narration/dialogue_6.ogg"), preload("res://assets/audio/narration/dialogue_7.ogg"), preload("res://assets/audio/narration/dialogue_8.ogg"), preload("res://assets/audio/narration/dialogue_9.ogg"),preload("res://assets/audio/narration/dialogue_10.ogg"), preload("res://assets/audio/narration/dialogue_11.ogg"), preload("res://assets/audio/narration/dialogue_12.ogg"), preload("res://assets/audio/narration/dialogue_13.ogg"), preload("res://assets/audio/narration/dialogue_14.ogg"), preload("res://assets/audio/narration/dialogue_15.ogg"), preload("res://assets/audio/narration/dialogue_16.ogg"), preload("res://assets/audio/narration/dialogue_17.ogg"), preload("res://assets/audio/narration/dialogue_18.ogg"), preload("res://assets/audio/narration/dialogue_19.ogg"), preload("res://assets/audio/narration/dialogue_20.ogg"), 
preload("res://assets/audio/narration/dialogue_21.ogg"), preload("res://assets/audio/narration/dialogue_22.ogg"), preload("res://assets/audio/narration/dialogue_23.ogg")
]
@onready var player: Player = $Player
@onready var tree_parent: Node2D = $TreeParent
@onready var tree_timer: Timer = $TreeTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var subtitles: Label = $CanvasLayer/Control/Subtitles
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var narration: AudioStreamPlayer = $Narration


class Checkpoint:
	var pos := 0.0
	var obstacles: Array[PackedScene] = []
	var animation := ""
	var text := ""
	var ambient_text := ""
	var audio: AudioStream

	func _init(_pos: float,
	_obstacles: Array[PackedScene] = [],
	_animation := "",
	_text := "",
	_ambient_text := "",
	_audio: AudioStream = null,
	) -> void:
		pos = _pos
		obstacles = _obstacles
		animation = _animation
		text = _text
		ambient_text = _ambient_text
		audio = _audio


func _ready() -> void:
	if GameManager.loaded:
		current_checkpoint = GameManager.load_game()
		GameManager.loaded = false
		go_to_checkpoint()
	change_checkpoint()


func _process(_delta: float) -> void:
	var pos := round(player.position.x)
	$CanvasLayer/Control/Label.text = str(pos)
	if pos >= max_distance:
		animation_player.play("ending")
	if current_checkpoint >= checkpoints.size() -1:
		return
	if pos >= checkpoints[current_checkpoint + 1].pos:
		current_checkpoint += 1
		change_checkpoint()


func go_to_checkpoint() -> void:
	player.position.x = checkpoints[current_checkpoint].pos + 1
	player.position.y = 160


func free_camera() -> void:
	player.can_move = false
#	player.camera_2d.limit_left = 0
#	player.camera_2d.limit_top = 0
#	player.camera_2d.limit_right = 1
#	player.camera_2d.limit_bottom = 1
	player.global_position = Vector2.ZERO
	player.camera_2d.offset.x = 960
#	player.camera_2d.offset = Vector2.ZERO


func ending() -> void:
	get_tree().change_scene_to_file("res://src/ending.tscn")


func change_checkpoint() -> void:
	GameManager.save_game(current_checkpoint)
	if not checkpoints[current_checkpoint].animation.is_empty():
		animation_player.play(checkpoints[current_checkpoint].animation)
	match current_checkpoint:
		0:
			tree_timer.start()
	subtitles.text = checkpoints[current_checkpoint].text
	narration.stream = narrations[current_checkpoint]
	narration.play()
	if checkpoints[current_checkpoint].audio:
		audio_stream_player.stream = checkpoints[current_checkpoint].audio
		audio_stream_player.play()
	if GameManager.show_ambient_subtitles:
		subtitles.text += "\n" + checkpoints[current_checkpoint].ambient_text


func _on_obstacle_timer_timeout() -> void:
	var obstacle: Obstacle = checkpoints[current_checkpoint].obstacles.pick_random().instantiate()
	obstacle.player_pos = player.position
	add_child(obstacle)


func _on_tree_timer_timeout() -> void:
	var pos := Vector2(player.position.x + 2040, 1080)
	var tree := tree_tscn.instantiate()
	tree.position = pos
	tree_parent.add_child(tree)
	if player.position.x > checkpoints[7].pos:
		tree.collapse()
		tree_timer.stop()
	elif player.position.x > checkpoints[6].pos:
		tree_timer.wait_time = randf_range(3, 5)
		tree.collapse()
	elif player.position.x > checkpoints[5].pos:
		tree_timer.wait_time = randf_range(2, 4)
		if randi() % 2 == 0:
			tree.collapse()
	elif player.position.x > checkpoints[4].pos:
		tree_timer.wait_time = randf_range(1, 3)
		if randi() % 3 == 0:
			tree.collapse()
	elif player.position.x > checkpoints[2].pos:
		tree_timer.wait_time = randf_range(1, 2)
	elif player.position.x > checkpoints[1].pos:
		tree_timer.wait_time = randf_range(0.4, 2)
	else:
		tree_timer.wait_time = randf_range(0.1, 0.4)
