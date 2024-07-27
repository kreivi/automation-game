# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

## 
class_name Slot extends Control

@export var data: QuantitativeData

@export_group("ControlComponents")
@export var connection_button: BaseButton
@export var ingredient_label: Label

func _ready() -> void:
	if connection_button.button_down.connect(_on_connection_started):
		push_warning("Failed to connect 'button_down' signal")
		pass
	if connection_button.button_up.connect(_on_connection_ended):
		push_warning("Failed to connect 'button_up' signal")
		pass
	ingredient_label.text = data.ingredient.id
	pass

func _on_connection_started() -> void:
	print("%s connection started" % name)
	pass

func _on_connection_ended() -> void:
	print("%s connection ended" % name)
	pass