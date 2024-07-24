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

## Maximum amount of ingredients that can be in the input slot.
var maximum_input: QuantitativeData
## Maximum amount of ingredients that can be in the output slot.
var maximum_output: QuantitativeData


#region Node Interface

func _ready() -> void:
	input_container.visible = input_requirement != null
	output_container.visible = output_requirement != null
	input_label.text = input_requirement.ingredient.id if input_requirement else ""
	output_label.text = output_requirement.ingredient.id if output_requirement else ""
	pass

#endregion Node Interface
