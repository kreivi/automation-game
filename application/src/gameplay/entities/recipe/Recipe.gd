# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

## 
class_name Recipe extends Control

signal input_connected(ingredient: IngredientData)
signal output_connected(ingredient: IngredientData)

@export var data: RecipeData

## Scene to instantiate for recipe inputs.
@export var input_slot_scene: PackedScene
## Scene to instantiate for recipe outputs.
@export var output_slot_scene: PackedScene

@export_group("ControlComponents")
@export var inputs_container: Container
@export var outputs_container: Container

#region Node Interface

func _ready() -> void:
	_init_slots()
	pass

#endregion Node Interface

#region Private Methods

func _init_slots() -> void:
	for i in data.inputs:
		_init_input(i)
	for o in data.outputs:
		_init_output(o)
	pass


func _init_input(quantative: QuantitativeData) -> void:
	var instance := input_slot_scene.instantiate() as Slot
	instance.data = quantative
	inputs_container.add_child(instance)
	pass


func _init_output(ingredient: QuantitativeData) -> void:
	var instance := output_slot_scene.instantiate() as Slot
	instance.data = ingredient
	outputs_container.add_child(instance)
	pass

#endregion Private Methods