# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

## Base class for all placeable entities in the game.
class_name Entity extends GraphElement

var graph_edit: GraphEdit

#region Node Interface

func _ready() -> void:
	if not graph_edit: graph_edit = get_parent() as GraphEdit
	Events.simulation_ticked.connect(_on_simulation_ticked)
	Events.simulation_paused.connect(_on_simulation_paused)
	pass

#endregion Node Interface

#region Protected Methods

## Called when the simulation progresses.
@warning_ignore("unused_parameter")
func _on_simulation_ticked(ticks: int, ticks_per_second: float) -> void: pass

## Called when the simulation is paused/unpaused.
@warning_ignore("unused_parameter")
func _on_simulation_paused(paused: bool) -> void: pass

#endregion Protected Methods
