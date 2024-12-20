extends Node

@onready var timer_tick_sound: AudioStreamPlayer2D = $TimerTickSound
@onready var timer_go_sound: AudioStreamPlayer2D = $TimerGoSound
@onready var guess_correct_sound: AudioStreamPlayer2D = $GuessCorrectSound
@onready var guess_wrong_sound: AudioStreamPlayer2D = $GuessWrongSound

@onready var gameplay_music: AudioStreamPlayer2D = $GameplayMusic
@onready var menu_music: AudioStreamPlayer2D = $MenuMusic
