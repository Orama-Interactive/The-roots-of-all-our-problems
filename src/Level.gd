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

var current_checkpoint := 0
var narrations: Array[AudioStream] = [
	preload("res://assets/audio/narration/dialogue_6.ogg"), preload("res://assets/audio/narration/dialogue_7.ogg"),
	preload("res://assets/audio/narration/dialogue_8.ogg"),preload("res://assets/audio/narration/dialogue_10.ogg"),
	preload("res://assets/audio/narration/dialogue_11.ogg"), preload("res://assets/audio/narration/dialogue_13.ogg"),
	preload("res://assets/audio/narration/dialogue_14.ogg"), preload("res://assets/audio/narration/dialogue_16.ogg"), preload("res://assets/audio/narration/dialogue_17.ogg"), preload("res://assets/audio/narration/dialogue_19.ogg"), preload("res://assets/audio/narration/dialogue_20.ogg"),
	preload("res://assets/audio/narration/dialogue_21.ogg"), preload("res://assets/audio/narration/dialogue_22.ogg"), preload("res://assets/audio/narration/dialogue_23.ogg")
]
var tree_collapse_percentage := -1
@onready var player: Player = $Player
@onready var bomb: AnimatedSprite2D = $ParallaxBackground/Bomb
@onready var middle_layer: Sprite2D = $ParallaxBackground/ParallaxLayer/MiddleLayer
@onready var front_layer: Sprite2D = $ParallaxBackground/ParallaxLayer2/FrontLayer
@onready var scene_end: ColorRect = $CanvasLayer/Control/SceneEnd
@onready var tree_parent: Node2D = $TreeParent
@onready var tree_timer: Timer = $TreeTimer
@onready var world_boundary: StaticBody2D = $WorldBoundary
@onready var subtitles: Label = $CanvasLayer/Control/Subtitles
@onready var sounds: AudioStreamPlayer = $Sounds
@onready var sounds_2: AudioStreamPlayer = $Sounds2
@onready var sounds_3: AudioStreamPlayer = $Sounds3
@onready var music: AudioStreamPlayer = $Music
@onready var narration: AudioStreamPlayer = $Narration

@onready var checkpoints: Array[Checkpoint] = [
	Checkpoint.new(0, forest_obstacles, [
		Event.new(play_sound, [sounds, preload("res://assets/audio/sounds/forest_ambience.wav")]),
		Event.new(spawn_trees, [0.1, 0.4])
	], "The seed flew east, through a forest. (hold [space] to jump)", "[forest ambience]"),
	Checkpoint.new(1500, forest_obstacles, [Event.new(spawn_trees, [0.4, 2])], "Navigating its way through the forest, the seed had to avoid the tree tops"),
	Checkpoint.new(3000, forest_obstacles, [Event.new(spawn_trees, [1, 2])], "“This forest is way too dense” the seed thought. I won’t be able to root properly here, with so little sun."),
	Checkpoint.new(4500, forest_obstacles, [
		Event.new(play_sound, [sounds_2, preload("res://assets/audio/sounds/chop_tree_far.mp3")]),
		Event.new(play_sound, [sounds_3, preload("res://assets/audio/sounds/chop_tree_close.mp3")], 2),
		Event.new(spawn_trees, [1, 3, 3])
	], "But then, the seed lost its train of thought to a cracking sound.", "[sound of a tree being chopped and sound of trees falling]"),
	Checkpoint.new(6000, forest_obstacles_2, [], "Why are the trees falling out of nowhere? Maybe that’s my chance to root!"),
	Checkpoint.new(7500, forest_obstacles_2, [], "But as the seed navigated further into the forest it realised that this place is far from safe.", "[sounds of rocks and arrows]"),
	Checkpoint.new(9000, forest_obstacles_2, [
		Event.new(fade_out, [middle_layer]),
		Event.new(stop_sound, [sounds_2]),
		Event.new(spawn_trees, [2, 4, 2])
	], "The trees were falling one after the other. What could have caused such a catastrophe?"),
	Checkpoint.new(10500, forest_obstacles_2, [
		Event.new(fade_out, [front_layer]),
		Event.new(stop_sound, [sounds_3]),
		Event.new(spawn_trees, [3, 5, 1])
	], "I have to travel further, the seed thought and it gathered all of its strength and courage to go even further."),
	Checkpoint.new(12000, city_obstacles, [
		Event.new(play_sound, [sounds, preload("res://assets/audio/sounds/busy_city.wav")]),
		Event.new(change_texture, [middle_layer, preload("res://assets/level_backgrounds/sidescrolling_town.png")]),
		Event.new(fade_in, [middle_layer]),
		Event.new(stop_trees)
	], "But things were getting even more weird the further it went. The forest lost its colours and the sound became louder and louder", "[sounds of a busy city]"),
	Checkpoint.new(13500, city_obstacles, [
		Event.new(change_texture, [front_layer, preload("res://assets/level_backgrounds/sidescrolling_town_2.png")]),
		Event.new(fade_in, [front_layer])
	], "“There’s barely any soil here, how will I find a place to root?” The seed thought as it traveled even further in that gray looking forest."),
	Checkpoint.new(15000, city_obstacles, [
		Event.new(play_sound, [sounds, preload("res://assets/audio/sounds/explosion.mp3"), 0]),
		Event.new(fade_in, [bomb]),
		Event.new(fade_out, [middle_layer]),
		Event.new(fade_out, [front_layer], 1),
		Event.new(fade_out, [bomb], 12),
	], "And suddenly, a sound unlike any other.", "[bomb falling, exploding]"),
	Checkpoint.new(20500, war_obstacles, [
		Event.new(play_sound, [music, preload("res://assets/audio/sounds/distant-warfare-51848.mp3"), 0])
	], "And everything was calm again."),
	Checkpoint.new(22000, war_obstacles, [], "The forest was long gone."),
	Checkpoint.new(24000, war_obstacles, [], "But the poor seed had little strength, for it had used all of its energy looking for a better place to root."),
	Checkpoint.new(27000, [], [
		Event.new(fade_in, [scene_end]),
		Event.new(ending, [], 2)
	], "But the poor seed had little strength, for it had used all of its energy looking for a better place to root."),
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
	var pos := 0.0
	var obstacles: Array[PackedScene] = []
	var events: Array[Event] = []
	var text := ""
	var ambient_text := ""

	func _init(_pos: float,
	_obstacles: Array[PackedScene] = [],
	_events: Array[Event] = [],
	_text := "",
	_ambient_text := "",
	) -> void:
		pos = _pos
		obstacles = _obstacles
		events = _events
		text = _text
		ambient_text = _ambient_text


	func fire_events(node: Node) -> void:
		for event in events:
			event.fire(node)


func _ready() -> void:
	if GameManager.loaded:
		current_checkpoint = GameManager.load_game()
		GameManager.loaded = false
		go_to_checkpoint()
	change_checkpoint()


func _process(_delta: float) -> void:
	var pos := roundf(player.position.x)
	world_boundary.position.x = player.position.x
	$CanvasLayer/Control/Label.text = str(pos)
	if current_checkpoint >= checkpoints.size() -1:
		return
	if pos >= checkpoints[current_checkpoint + 1].pos:
		current_checkpoint += 1
		change_checkpoint()


func go_to_checkpoint() -> void:
	player.position.x = checkpoints[current_checkpoint].pos + 1
	player.position.y = 160


func change_checkpoint() -> void:
	if current_checkpoint < checkpoints.size() - 1:  # Do not save the final checkpoint
		GameManager.save_game(current_checkpoint)
	checkpoints[current_checkpoint].fire_events(self)
	match current_checkpoint:
		0:
			tree_timer.start()
	subtitles.text = checkpoints[current_checkpoint].text
	if current_checkpoint < narrations.size():
		narration.stream = narrations[current_checkpoint]
		narration.play()
	if GameManager.show_ambient_subtitles:
		subtitles.text += "\n" + checkpoints[current_checkpoint].ambient_text


func _on_obstacle_timer_timeout() -> void:
	if checkpoints[current_checkpoint].obstacles.is_empty():
		return
	var obstacle: Obstacle = checkpoints[current_checkpoint].obstacles.pick_random().instantiate()
	obstacle.player_pos = player.position
	add_child(obstacle)


func _on_tree_timer_timeout() -> void:
	var pos := Vector2(player.position.x + 2040, 1080)
	var tree := tree_tscn.instantiate()
	tree.position = pos
	tree_parent.add_child(tree)
	if tree_collapse_percentage > -1:
		if randi() % tree_collapse_percentage == 0:
			tree.collapse()


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
