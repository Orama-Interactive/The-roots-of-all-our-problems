extends Node2D

@export_multiline var dialogue_lines: Array[String] = []

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

var current_checkpoint := -1
var narrations: Array[AudioStream] = [
	preload("res://assets/audio/narration/level/1.ogg"), preload("res://assets/audio/narration/level/2.ogg"), preload("res://assets/audio/narration/level/3.ogg"), preload("res://assets/audio/narration/level/4.ogg"), preload("res://assets/audio/narration/level/5.ogg"), preload("res://assets/audio/narration/level/6.ogg"), preload("res://assets/audio/narration/level/7.ogg"), preload("res://assets/audio/narration/level/8.ogg"), preload("res://assets/audio/narration/level/9.ogg"), preload("res://assets/audio/narration/level/10.ogg"), preload("res://assets/audio/narration/level/11.ogg"), preload("res://assets/audio/narration/level/12.ogg"), preload("res://assets/audio/narration/level/13.ogg"), preload("res://assets/audio/narration/level/14.ogg"), preload("res://assets/audio/narration/level/15.ogg"), preload("res://assets/audio/narration/level/16.ogg"), preload("res://assets/audio/narration/level/17.ogg"), preload("res://assets/audio/narration/level/18.ogg"), preload("res://assets/audio/narration/level/19.ogg"), preload("res://assets/audio/narration/level/20.ogg"), preload("res://assets/audio/narration/level/21.ogg")
]
var tree_collapse_percentage := -1
@onready var player: Player = $Player
@onready var background: Sprite2D = $ParallaxBackground/Background
@onready var bomb: AnimatedSprite2D = $ParallaxBackground/Bomb
@onready var middle_layer: Sprite2D = $ParallaxBackground/ParallaxLayer/MiddleLayer
@onready var front_layer: Sprite2D = $ParallaxBackground/ParallaxLayer2/FrontLayer
@onready var scene_end: ColorRect = $CanvasLayer/Control/SceneEnd
@onready var tree_parent: Node2D = $TreeParent
@onready var tree_timer: Timer = $TreeTimer
@onready var world_boundary: StaticBody2D = $WorldBoundary
@onready var subtitles: Label = $CanvasLayer/Control/Subtitles
@onready var tutorial: Label = $CanvasLayer/Control/Tutorial
@onready var sounds: AudioStreamPlayer = $Sounds
@onready var sounds_2: AudioStreamPlayer = $Sounds2
@onready var sounds_3: AudioStreamPlayer = $Sounds3
@onready var music: AudioStreamPlayer = $Music
@onready var narration: AudioStreamPlayer = $Narration

@onready var checkpoints: Array[Checkpoint] = [
	Checkpoint.new([], [
		Event.new(play_sound, [sounds, preload("res://assets/audio/sounds/forest_ambience.wav")]),
		Event.new(spawn_trees, [0.1, 0.4])
	], "[forest ambience]"),
	Checkpoint.new(forest_obstacles, [Event.new(spawn_trees, [0.4, 2])],),
	Checkpoint.new(forest_obstacles, [Event.new(spawn_trees, [1, 2])]),
	Checkpoint.new(forest_obstacles, [
		Event.new(play_sound, [sounds_2, preload("res://assets/audio/sounds/chop_tree_far.mp3")]),
		Event.new(play_sound, [sounds_3, preload("res://assets/audio/sounds/chop_tree_close.mp3")], 2),
		Event.new(spawn_trees, [1, 3, 3])
	], "[Trees being chopped with axes and trees falling]"),
	Checkpoint.new(forest_obstacles_2, [Event.new(spawn_trees, [1.2, 3, 3])],),
	Checkpoint.new(forest_obstacles_2, [Event.new(spawn_trees, [1.3, 3.3, 3])]),
	Checkpoint.new(forest_obstacles_2, [Event.new(spawn_trees, [1.3, 3.3, 3])]),
	Checkpoint.new(forest_obstacles_2, [
		Event.new(fade_out, [middle_layer]),
		Event.new(stop_sound, [sounds_2]),
		Event.new(spawn_trees, [2, 4, 2])
	]),
	Checkpoint.new(forest_obstacles_2, [
		Event.new(fade_out, [front_layer]),
		Event.new(stop_sound, [sounds_3]),
		Event.new(spawn_trees, [3, 5, 1])
	]),
	Checkpoint.new(city_obstacles, [
		Event.new(play_sound, [sounds, preload("res://assets/audio/sounds/busy_city.wav")]),
		Event.new(change_texture, [background, preload("res://assets/level_backgrounds/sky_background_city.png")]),
		Event.new(change_texture, [middle_layer, preload("res://assets/level_backgrounds/sidescrolling_town.png")]),
		Event.new(fade_in, [middle_layer]),
		Event.new(stop_trees)
	], "[sounds of a busy city]"),
	Checkpoint.new(city_obstacles, [
		Event.new(change_texture, [front_layer, preload("res://assets/level_backgrounds/sidescrolling_town_2.png")]),
		Event.new(fade_in, [front_layer])
	]),
	Checkpoint.new(city_obstacles),
	Checkpoint.new(city_obstacles),
	Checkpoint.new(city_obstacles),
	Checkpoint.new(city_obstacles, [
		Event.new(play_sound, [sounds, preload("res://assets/audio/sounds/explosion.mp3"), 0]),
		Event.new(change_texture, [background, preload("res://assets/level_backgrounds/sky_background_war.png")]),
		Event.new(fade_in, [bomb]),
		Event.new(fade_out, [middle_layer]),
		Event.new(fade_out, [front_layer], 1),
		Event.new(fade_out, [bomb], 12),
	], "[bomb falling, exploding]"),
	Checkpoint.new(war_obstacles, [
		Event.new(play_sound, [music, preload("res://assets/audio/sounds/distant-warfare-51848.mp3"), 0])
	]),
	Checkpoint.new(war_obstacles, []),
	Checkpoint.new(war_obstacles, []),
	Checkpoint.new(war_obstacles, []),
	Checkpoint.new(war_obstacles, []),
	Checkpoint.new([], [
		Event.new(fade_in, [scene_end]),
		Event.new(ending, [], 2)
	]),
]


class Event:
	var callable: Callable
	var args := []
	var delay := 0.0

	func _init(_callable: Callable, _args := [], _delay := 0.0) -> void:
		callable = _callable
		args = _args
		delay = _delay


	func fire(node: Node) -> void:
		if delay > 0.0:
			await node.get_tree().create_timer(delay).timeout
		callable.callv(args)


class Checkpoint:
	var obstacles: Array[PackedScene] = []
	var events: Array[Event] = []
	var text := ""
	var ambient_text := ""

	func _init(
	_obstacles: Array[PackedScene] = [],
	_events: Array[Event] = [],
	_ambient_text := "",
	) -> void:
		obstacles = _obstacles
		events = _events
		ambient_text = _ambient_text


	func fire_events(node: Node) -> void:
		for event in events:
			event.fire(node)


func _ready() -> void:
	if GameManager.loaded:
		player.can_move = true
		current_checkpoint = GameManager.load_game()
		GameManager.loaded = false
		go_to_checkpoint()
		change_checkpoint()
	else:
		tree_timer.start()


func _process(_delta: float) -> void:
	var pos := roundf(player.position.x)
	world_boundary.position.x = player.position.x
	$CanvasLayer/Control/Label.text = str(pos)
	if current_checkpoint >= checkpoints.size() -1:
		return
	if pos >= _calculate_checkpoint_position(current_checkpoint + 1):
		current_checkpoint += 1
		change_checkpoint()


func go_to_checkpoint() -> void:
	player.position.x = _calculate_checkpoint_position(current_checkpoint) + 1
	player.position.y = 160


func change_checkpoint() -> void:
	if current_checkpoint < checkpoints.size() - 1:  # Do not save the final checkpoint
		GameManager.save_game(current_checkpoint)
	checkpoints[current_checkpoint].fire_events(self)
	if current_checkpoint < narrations.size():
		subtitles.text = dialogue_lines[current_checkpoint]
		narration.stream = narrations[current_checkpoint]
		narration.play()
	if GameManager.show_ambient_subtitles:
		subtitles.text += "\n" + checkpoints[current_checkpoint].ambient_text


func _calculate_checkpoint_position(index: int) -> float:
	if index < 8:
		return index * 2000.0 + 1000.0
	else:  # Increase checkpoint distance exponentially
		return pow(index / 2.0, 2) * 1000.0 + 1000.0


func _on_obstacle_timer_timeout() -> void:
	if checkpoints[current_checkpoint].obstacles.is_empty():
		return
	var obstacle: Obstacle = checkpoints[current_checkpoint].obstacles.pick_random().instantiate()
	obstacle.player_pos = player.position
	add_child(obstacle)


func _on_tree_timer_timeout() -> void:
	var offset := 1680 if player.position.x < 1000 else 1300
	var pos := Vector2(player.position.x + player.camera_2d.position.x + offset, 1080)
	var tree: BackgroundTree = tree_tscn.instantiate()
	if current_checkpoint > -1:
		tree.despawn_limit = _calculate_checkpoint_position(current_checkpoint) - 400
	tree.position = pos
	tree_parent.add_child(tree)
	if tree_collapse_percentage > -1:
		if randi() % tree_collapse_percentage == 0:
			tree.collapse()


func _on_player_fell() -> void:
	world_boundary.get_node("BottomLimit").set_deferred("disabled", true)


func enable_bottom_limit() -> void:
	world_boundary.get_node("BottomLimit").disabled = false


# Events
func change_texture(sprite: Sprite2D, texture: Texture2D) -> void:
	sprite.texture = texture
	sprite.position.y = 1080 - texture.get_height()


func fade_in(ci: CanvasItem, duration := 1.0) -> void:
	var color := ci.modulate
	color.a = 1
	create_tween().tween_property(ci, "modulate", color, duration)


func fade_out(ci: CanvasItem, duration := 1.0) -> void:
	var color := ci.modulate
	color.a = 0
	create_tween().tween_property(ci, "modulate", color, duration)


func play_sound(asp: AudioStreamPlayer, audio: AudioStream, volume: float = 99, duration := 1.0) -> void:
	if asp.stream == audio:
		return
	asp.stream = audio
	asp.play()
	if is_equal_approx(volume, 99):  # Don't change volume
		return
	create_tween().tween_property(asp, "volume_db", volume, duration)


func stop_sound(asp: AudioStreamPlayer) -> void:
	asp.stop()


func spawn_trees(from: float, to: float, collapse := -1) -> void:
	tree_timer.wait_time = randf_range(from, to)
	tree_collapse_percentage = collapse
	tree_timer.start()


func stop_trees() -> void:
	tree_timer.stop()


func ending() -> void:
	get_tree().change_scene_to_file("res://src/ending.tscn")
