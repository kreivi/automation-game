# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

## Single slot for processor input/output. Leaving either empty will disable the connectivity.
class_name IOSlot extends HBoxContainer

## Recipe ID this slot is associated with.
@export var recipe_id: String
## Slot input data requirement.
@export var input_requirement: QuantitativeData
## Slot output data requirement.
@export var output_requirement: QuantitativeData

## How much storage is available for input.
@export var input_storage: QuantitativeData
## How much storage is available for output.
@export var output_storage: QuantitativeData

@export_group("NodePaths")

@export var input_container: Control
@export var input_label: Label
@export var input_progress: ProgressBar

@export var output_container: Control
@export var output_label: Label
@export var output_progress: ProgressBar

## How much ingredients are currently in the input slot.
var current_input: QuantitativeData
## How much ingredients are currently in the output slot.
var current_output: QuantitativeData

#region Node Interface

func _ready() -> void:
	input_container.visible = input_requirement != null
	output_container.visible = output_requirement != null
	input_label.text = input_requirement.ingredient.id if input_requirement else ""
	output_label.text = output_requirement.ingredient.id if output_requirement else ""
	current_input = QuantitativeData.new()
	current_input.ingredient = input_requirement.ingredient if input_requirement else null
	current_output = QuantitativeData.new()
	current_output.ingredient = output_requirement.ingredient if output_requirement else null
	
	pass

#endregion Node Interface

#region Public Methods

func process_slot(ticks: int) -> void:
	if not input_requirement or input_requirement.quantity <= 0:
		current_input.quantity += ticks
		pass
		
	pass

## Returns whether the input requirements of this slot is satisfied.
func input_satisfied() -> bool:
	return not input_requirement or current_input.quantity >= input_requirement.quantity


#endregion Public Methods