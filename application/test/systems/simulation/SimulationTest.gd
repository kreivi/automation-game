# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

## 
extends Node

@export var simulation: Simulation
@export var ticks_value_label: Label
@export var ticks_per_second_value_label: Label
@export var pause_button: Button

func _ready() -> void:
	Events.simulation_ticked.connect(_on_simulation_ticked)
	Events.simulation_paused.connect(_on_simulation_paused)
	pause_button.pressed.connect(_on_pause_button_pressed)
	pass


func _on_pause_button_pressed() -> void:
	simulation.paused = not simulation.paused
	pass


func _on_simulation_ticked(ticks: int, ticks_per_second: float) -> void:
	ticks_value_label.text = str(int(ticks_value_label.text) + ticks)
	ticks_per_second_value_label.text = str(ticks_per_second)
	pass


func _on_simulation_paused(paused: bool) -> void:
	pause_button.text = "Resume" if paused else "Pause"
	pass
