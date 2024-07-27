# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

##
class_name Processor extends Entity

@export var data: ProcessorData

@export var ioslot_scene: PackedScene

#region Node interface

func _ready() -> void:
	super._ready()
	title = data.id
	_init_slots()
	pass

#endregion Node interface

#region Entity interface

func _on_simulation_ticked(ticks: int, ticks_per_second: float) -> void:
	super._on_simulation_ticked(ticks, ticks_per_second)
	_process_recipes(ticks)
	pass

#endregion Entity interface


func _init_slots() -> void:
	for recipe in data.recipes:
		_init_slot(recipe)
	pass


func _init_slot(recipe: RecipeData) -> void:
	var slots := maxi(recipe.inputs.size(), recipe.outputs.size())
	for i in range(slots):
		var ioslot := ioslot_scene.instantiate() as IOSlot
		ioslot.recipe_id = recipe.id
		if i < recipe.inputs.size():
			var input := recipe.inputs[i]
			ioslot.input_requirement = input
			set_slot_enabled_left(i, true)
			set_slot_type_left(i, input.ingredient.type)
			pass
		if i < recipe.outputs.size():
			var output := recipe.outputs[i]
			ioslot.output_requirement = output
			set_slot_enabled_right(i, true)
			set_slot_type_right(i, output.ingredient.type)
			pass
		add_child(ioslot)
		pass
	pass


func _process_recipes(ticks: int) -> void:
	for recipe in data.recipes:
		_process_recipe(recipe, ticks)
		pass
	pass


func _process_recipe(recipe: RecipeData, ticks: int) -> void:
	var slots := _get_recipe_slots(recipe.id)
	for slot: IOSlot in slots:
		slot.process_slot(ticks)
		pass
	pass


## Returns all slots that are assosiated with the given recipe.
func _get_recipe_slots(recipe_id: String) -> Array[IOSlot]:
	var slots := []
	for child: IOSlot in get_children():
		if child is IOSlot:
			if child.recipe_id == recipe_id:
				slots.append(child)
				pass
			pass
		pass
	return slots


func output_connected(port_index: int) -> void:
	print("Processor output connected %d:%d:%d" % [port_index, get_output_port_slot(port_index), get_output_port_type(port_index)])
	pass


func input_connected(port_index: int) -> void:
	print("Processor input connected %d:%d:%d" % [port_index, get_input_port_slot(port_index), get_input_port_type(port_index)])
	pass