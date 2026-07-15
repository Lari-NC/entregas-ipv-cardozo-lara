@tool

extends Node

@onready var input: Label = $MarginContainer/HBoxContainer/PanelInput/Input
@onready var action: Label = $MarginContainer/HBoxContainer/PanelAction/Action

@export var action_input: String: set = _set_action_input
@export var action_name: String: set = _set_action_name

func _ready() -> void:
	input.text = action_input
	action.text = action_name

func _set_action_input(new_input: String) -> void:
	action_input = new_input
	if Engine.is_editor_hint() && has_node("HBoxContainer/PanelInput/Input"):
		input.text = new_input

func _set_action_name(new_name: String) -> void:
	action_name = new_name
	if Engine.is_editor_hint() && has_node("HBoxContainer/PanelAction/Action"):
		action.text = new_name
