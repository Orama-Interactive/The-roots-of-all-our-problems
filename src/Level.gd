extends Node2D

var obstacle_tscn := preload("res://src/obstacle.tscn")
var tree_tscn := preload("res://src/tree.tscn")
var checkpoints: Array[float] = [0, 700, 1200, 1700]
var subs: PackedStringArray = [
	"The seed flew east, through a forest. (press [space] to jump)",
	"Navigating its way through the forest, the seed had to avoid the tree tops",
	"“This forest is way too dense” the seed thought. I won’t be able to root properly here, with so little sun.",
	"But then, the seed lost its train of thought to a cracking sound.",
	"Why are the trees falling out of nowhere? Maybe that’s my chance to root!",
	"But as the seed navigated further into the forest it realised that this place is far from safe.",
	"The trees were falling one after the other. What could have caused such a catastrophe?",
	"I have to travel further, the seed thought and it gathered all of its strength and courage to go even further.",
	"But things were getting even more weird the further it went. The forest lost its colours and the sound became louder and louder",
	"“There’s barely any soil here, how will I find a place to root?” The seed thought as it traveled even further in that gray looking forest.",
	"And suddenly, a sound unlike any other.",
	"And everything was calm again.",
	"The forest was long gone.",
	"But the poor seed had little strength, for it had used all of its energy looking for a better place to root.",
	"Maybe this place were never meant to be found. Because of a greedy species with zero consideration for nature or even its own kind was a bad encounter in the seed’s adventure that it shouldn’t have to have.",
	"A parasite, here only to destroy. Periods of conflict followed, leaving fire and blood at their trails. Hope was naught but a faint light, yet wars were in humanity’s nature, never to be stopped.",
]
var ambient_sounds: PackedStringArray = [
	"(forest ambience)",
	"",
	"",
	"(sound of a tree being chopped and sound of trees falling)",
	"",
	"(sounds of rocks and arrows+new obstacles)",
	"",
	"",
	"(sounds of a busy city)",
	"",
	"(Bomb falling, exploding) ",
	"(sound of fire) ",
	"",
	"",
	"",
	"",
]
var current_checkpoint := 0
@onready var player: Player = $Player
@onready var tree_parent: Node2D = $TreeParent
@onready var tree_timer: Timer = $TreeTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var subtitles: Label = $CanvasLayer/Control/Subtitles


func _ready() -> void:
	if GameManager.loaded:
		current_checkpoint = GameManager.load()
		player.position.x = checkpoints[current_checkpoint] + 1
	change_checkpoint()


func _process(_delta: float) -> void:
	var pos := round(player.position.x)
	$CanvasLayer/Control/Label.text = str(pos)
	if current_checkpoint >= checkpoints.size() -1:
		return
	if pos >= checkpoints[current_checkpoint + 1]:
		current_checkpoint += 1
		change_checkpoint()


func change_checkpoint() -> void:
	GameManager.save(current_checkpoint)
	match current_checkpoint:
		0:
			tree_timer.start()
		1:
			animation_player.play("forest_fade_1")
		2:
			animation_player.play("forest_fade_2")
		3:
			animation_player.play("town_fade_in_1")
	subtitles.text = subs[current_checkpoint]
	if GameManager.show_ambient_subtitles:
		subtitles.text += "\n" + ambient_sounds[current_checkpoint]


func _on_obstacle_timer_timeout() -> void:
	var obstacle: Obstacle = obstacle_tscn.instantiate()
	var pos := Vector2(player.position.x + 1940, 0)
	obstacle.position = pos
	add_child(obstacle)


func _on_tree_timer_timeout() -> void:
	var pos := Vector2(player.position.x + 2040, 1080)
	var tree := tree_tscn.instantiate()
	tree.position = pos
	tree_parent.add_child(tree)
	if player.position.x > checkpoints[3]:
		tree_timer.stop()
	elif player.position.x > checkpoints[2]:
		tree_timer.wait_time = randf_range(4, 7)
	elif player.position.x > checkpoints[1]:
		tree_timer.wait_time = randf_range(1, 4)
	else:
		tree_timer.wait_time = randf_range(0.2, 2)
